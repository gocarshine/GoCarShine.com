import "jsr:@supabase/functions-js/edge-runtime.d.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization, X-Client-Info, Apikey",
};

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, {
      status: 200,
      headers: corsHeaders,
    });
  }

  try {
    const url = new URL(req.url);
    const path = url.pathname;

    if (path === "/functions/v1/user-logs" && req.method === "GET") {
      const userId = url.searchParams.get("userId");
      const action = url.searchParams.get("action");

      if (!userId) {
        return new Response(
          JSON.stringify({ error: "userId is required" }),
          {
            status: 400,
            headers: { ...corsHeaders, "Content-Type": "application/json" },
          }
        );
      }

      const response = await fetch(
        `${Deno.env.get("SUPABASE_URL")}/rest/v1/user_logs?user_id=eq.${userId}${action ? `&action=eq.${action}` : ""}&order=created_at.desc`,
        {
          headers: {
            Authorization: `Bearer ${Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")}`,
            "Content-Type": "application/json",
          },
        }
      );

      const logs = await response.json();

      return new Response(JSON.stringify(logs), {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    if (path === "/functions/v1/user-logs" && req.method === "POST") {
      const authHeader = req.headers.get("authorization");
      if (!authHeader) {
        return new Response(
          JSON.stringify({ error: "Unauthorized" }),
          {
            status: 401,
            headers: { ...corsHeaders, "Content-Type": "application/json" },
          }
        );
      }

      const body = await req.json();
      const { action, details } = body;

      if (!action) {
        return new Response(
          JSON.stringify({ error: "action is required" }),
          {
            status: 400,
            headers: { ...corsHeaders, "Content-Type": "application/json" },
          }
        );
      }

      const token = authHeader.replace("Bearer ", "");
      const userResponse = await fetch(
        `${Deno.env.get("SUPABASE_URL")}/auth/v1/user`,
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );

      if (!userResponse.ok) {
        return new Response(
          JSON.stringify({ error: "Invalid token" }),
          {
            status: 401,
            headers: { ...corsHeaders, "Content-Type": "application/json" },
          }
        );
      }

      const user = await userResponse.json();

      const logResponse = await fetch(
        `${Deno.env.get("SUPABASE_URL")}/rest/v1/user_logs`,
        {
          method: "POST",
          headers: {
            Authorization: `Bearer ${Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")}`,
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            user_id: user.id,
            action: action,
            details: details || null,
            ip_address: req.headers.get("x-forwarded-for") || "unknown",
            timestamp: new Date().toISOString(),
          }),
        }
      );

      if (!logResponse.ok) {
        throw new Error("Failed to create log");
      }

      const newLog = await logResponse.json();

      return new Response(JSON.stringify(newLog), {
        status: 201,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    return new Response(
      JSON.stringify({ error: "Not found" }),
      {
        status: 404,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  }
});