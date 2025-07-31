import { fail } from "@sveltejs/kit";
import type { Actions } from "./$types";

export const actions: Actions = {
  default: async ({ request, fetch }) => {
    const formData = await request.formData();
    const errors: Record<string, string> = {};

    // Validation (unchanged from your original)
    const firstName = formData.get("first_name")?.toString() ?? "";
    if (firstName.length < 2) errors["first_name"] = "First name is required";
    else if (firstName.length > 500) errors["first_name"] = "First name too long";

    const lastName = formData.get("last_name")?.toString() ?? "";
    if (lastName.length < 2) errors["last_name"] = "Last name is required";
    else if (lastName.length > 500) errors["last_name"] = "Last name too long";

    const email = formData.get("email")?.toString() ?? "";
    if (email.length < 6) errors["email"] = "Email is required";
    else if (email.length > 500) errors["email"] = "Email too long";
    else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) errors["email"] = "Invalid email";

    const company = formData.get("company")?.toString() ?? "";
    if (company.length > 500) errors["company"] = "Company too long";

    const phone = formData.get("phone")?.toString() ?? "";
    if (phone.length > 100) errors["phone"] = "Phone number too long";

    const message = formData.get("message")?.toString() ?? "";
    if (message.length > 2000) errors["message"] = `Message too long (${message.length} of 2000)`;

    if (Object.keys(errors).length > 0) {
      return fail(400, { errors });
    }

    // Send to Rocket backend
    try {
      const response = await fetch("http://localhost:8000/api/contact", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          first_name: firstName,
          last_name: lastName,
          email,
          company_name: company || null,
          phone: phone || null,
          message_body: message || null,
        }),
      });

      if (!response.ok) {
        const errorText = await response.text();
        console.error("Rocket backend error:", errorText);
        return fail(500, {
          errors: {
            _: "Error submitting form. Please try again later."
          }
        });
      }

      return { success: true };
    } catch (error) {
      console.error("Network error:", error);
      return fail(500, {
        errors: {
          _: "Could not connect to server. Please check your connection."
        }
      });
    }
  },
};