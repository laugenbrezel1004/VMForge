<script lang="ts">
  import { enhance } from "$app/forms"
  import type { SubmitFunction } from "@sveltejs/kit"
  import type { FullAutoFill } from "svelte/elements"

  //export let form;
  //export   $props()
  let form = $props();
  let loading = $state(false)

  interface FormField {
    id: string
    label: string
    inputType: string
    autocomplete: FullAutoFill
    required?: boolean
  }

  const formFields: FormField[] = [
    {
      id: "hostname",
      label: "Hostname *",
      inputType: "text",
      autocomplete: "given-name",
      required: true
    },
    {
      id: "cpu_cores",
      label: "CPU-Cores *",
      inputType: "number",
      autocomplete: "family-name",
      required: true
    },
  //  {
  //    id: "email",
  //    label: "Email *",
  //    inputType: "email",
  //    autocomplete: "email",
  //    required: true
  //  },
  //  {
  //    id: "phone",
  //    label: "Phone Number",
  //    inputType: "tel",
  //    autocomplete: "tel"
  //  },
  //  {
  //    id: "company",
  //    label: "Company Name",
  //    inputType: "text",
  //    autocomplete: "organization"
  //  },
  //  {
  //    id: "message",
  //    label: "Message",
  //    inputType: "textarea",
  //    autocomplete: "off"
  //  }
  ]

  const handleSubmit: SubmitFunction = ({ form }) => {
    loading = true
    return async ({ result }) => {
      loading = false
    }
  }
</script>

<div
  class="flex flex-col lg:flex-row mx-auto my-4 min-h-[70vh] place-items-center lg:place-items-start place-content-center">
  <div
    class="flex flex-col grow m-4 lg:ml-10 min-w-[300px] stdphone:min-w-[360px] max-w-[400px] place-content-center lg:min-h-[70vh]">
    {#if form?.success}
      <div class="flex flex-col place-content-center lg:min-h-[70vh]">
        <div class="card card-bordered shadow-lg py-6 px-6 mx-2 lg:mx-0 lg:p-6 mb-10">
          <div class="text-2xl font-bold mb-4">Thank you!</div>
          <p class="">Your VM will be created :)</p>
        </div>
      </div>
    {:else}
      <div class="card card-bordered shadow-lg p-4 pt-6 mx-2 lg:mx-0 lg:p-6">
        <form
          class="form-widget flex flex-col"
          method="POST"
          use:enhance={handleSubmit}
        >
          {#each formFields as field}
            <label for={field.id}>
              <div class="flex flex-row">
                <div class="text-base font-bold">{field.label}</div>
                {#if form?.errors?.[field.id]}
                  <div class="text-red-600 grow text-sm ml-2 text-right">
                    {form.errors[field.id]}
                  </div>
                {/if}
              </div>
              {#if field.inputType === "textarea"}
                <textarea
                  id={field.id}
                  name={field.id}
                  autocomplete={field.autocomplete}
                  rows={4}
                  required={field.required}
                  class="{form?.errors?.[field.id]
                    ? 'input-error'
                    : ''} h-24 input-sm mt-1 input input-bordered w-full mb-3 text-base py-4"
                ></textarea>
              {:else}
                <input
                  id={field.id}
                  name={field.id}
                  type={field.inputType}
                  autocomplete={field.autocomplete}
                  required={field.required}
                  class="{form?.errors?.[field.id]
                    ? 'input-error'
                    : ''} input-sm mt-1 input input-bordered w-full mb-3 text-base py-4"
                />
              {/if}
            </label>
          {/each}

          {#if form?.errors?._}
            <p class="text-red-600 text-sm mb-2">
              {form.errors._}
            </p>
          {:else if form?.errors && Object.keys(form.errors).length > 0}
            <p class="text-red-600 text-sm mb-2">
              Please resolve above issues.
            </p>
          {/if}

          <button class="btn btn-primary {loading ? 'btn-disabled' : ''}">
            {loading ? "Submitting..." : "Submit"}
          </button>
        </form>
      </div>
    {/if}
  </div>
</div>