// src/hooks.server.js
export async function handle({ event, resolve }) {
  // Example: Redirect from /old-path to /new-path
  if (event.url.pathname != '/') {
    return new Response(null, {
      status: 308, // Permanent redirect
      headers: {
        location: '/'
      }
    });
  }

  // Continue with normal processing if no redirect
  return await resolve(event);
}