// @ts-nocheck
// Supabase Edge Function: send-push
//
// Triggered by a Database Webhook on INSERT into `public.notifications`.
// Looks up the rider's saved device tokens and sends each one a push via
// the FCM HTTP v1 API.
//
// Deploy: supabase functions deploy send-push
// Requires these secrets (set via `supabase secrets set`):
//   FIREBASE_PROJECT_ID       — your Firebase project ID
//   FIREBASE_SERVICE_ACCOUNT  — the full service-account JSON (as one string)
//   SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY — usually already available by default

import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

interface WebhookPayload {
  type: "INSERT";
  table: string;
  record: {
    id: string;
    user_id: string;
    type: string | null;
    title: string | null;
    body: string | null;
  };
}

async function getAccessToken(): Promise<string> {
  const serviceAccount = JSON.parse(Deno.env.get("FIREBASE_SERVICE_ACCOUNT")!);

  const now = Math.floor(Date.now() / 1000);
  const header = { alg: "RS256", typ: "JWT" };
  const claims = {
    iss: serviceAccount.client_email,
    scope: "https://www.googleapis.com/auth/firebase.messaging",
    aud: "https://oauth2.googleapis.com/token",
    exp: now + 3600,
    iat: now,
  };

  const encode = (obj: unknown) =>
    btoa(JSON.stringify(obj)).replace(/=/g, "").replace(/\+/g, "-").replace(/\//g, "_");

  const unsigned = `${encode(header)}.${encode(claims)}`;

  const key = await crypto.subtle.importKey(
    "pkcs8",
    pemToBinary(serviceAccount.private_key),
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"],
  );
  const signature = await crypto.subtle.sign(
    "RSASSA-PKCS1-v1_5",
    key,
    new TextEncoder().encode(unsigned),
  );
  const signed = `${unsigned}.${btoa(String.fromCharCode(...new Uint8Array(signature)))
    .replace(/=/g, "")
    .replace(/\+/g, "-")
    .replace(/\//g, "_")}`;

  const tokenRes = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: `grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=${signed}`,
  });
  const tokenJson = await tokenRes.json();
  return tokenJson.access_token;
}

function pemToBinary(pem: string): ArrayBuffer {
  const clean = pem
    .replace(/-----BEGIN PRIVATE KEY-----/, "")
    .replace(/-----END PRIVATE KEY-----/, "")
    .replace(/\s/g, "");
  const bin = atob(clean);
  const bytes = new Uint8Array(bin.length);
  for (let i = 0; i < bin.length; i++) bytes[i] = bin.charCodeAt(i);
  return bytes.buffer;
}

Deno.serve(async (req) => {
  const payload: WebhookPayload = await req.json();
  const row = payload.record;

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const { data: tokens } = await supabase
    .from("device_tokens")
    .select("token")
    .eq("user_id", row.user_id);

  if (!tokens || tokens.length === 0) {
    return new Response(JSON.stringify({ skipped: "no device tokens" }), { status: 200 });
  }

  const accessToken = await getAccessToken();
  const projectId = Deno.env.get("FIREBASE_PROJECT_ID");

  const results = await Promise.all(
    tokens.map((t: { token: string }) =>
      fetch(`https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`, {
        method: "POST",
        headers: {
          Authorization: `Bearer ${accessToken}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          message: {
            token: t.token,
            notification: {
              title: row.title ?? "Wassalny",
              body: row.body ?? "",
            },
          },
        }),
      }),
    ),
  );

  return new Response(JSON.stringify({ sent: results.length }), { status: 200 });
});