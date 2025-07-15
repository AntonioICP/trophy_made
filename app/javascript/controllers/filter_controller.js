import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Auto-submit on checkbox change
    this.element.querySelectorAll('.filter-checkbox').forEach((checkbox) => {
      checkbox.addEventListener('change', (e) => {
        this.addOpenSections()
        this.element.submit()
      })
    })

    // Auto-submit on price input change
    this.element.querySelectorAll('.price-input').forEach((input) => {
      input.addEventListener('input', (e) => {
        this.debouncedSubmit()
      })
    })

    // Auto-submit on sort change
    this.element.querySelectorAll('.sort-select').forEach((select) => {
      select.addEventListener('change', (e) => {
        this.addOpenSections()
        this.element.submit()
      })
    })
  }

  debouncedSubmit() {
    clearTimeout(this.submitTimeout)
    this.submitTimeout = setTimeout(() => {
      this.addOpenSections()
      this.element.submit()
    }, 800) // 800ms delay to avoid too many requests while typing
  }

  addOpenSections() {
    const openSections = []

    // Check which sections are open
    if (document.getElementById('collapseSports')?.classList.contains('show')) {
      openSections.push('sports')
    }
    if (document.getElementById('collapseMaterials')?.classList.contains('show')) {
      openSections.push('materials')
    }
    if (document.getElementById('collapsePriceRange')?.classList.contains('show')) {
      openSections.push('price')
    }

    // Remove existing hidden fields
    this.element.querySelectorAll('input[name="open_sections[]"]').forEach(field => {
      field.remove()
    })

    // Add new hidden fields
    if (openSections.length > 0) {
      openSections.forEach(section => {
        const hiddenField = document.createElement('input')
        hiddenField.type = 'hidden'
        hiddenField.name = 'open_sections[]'
        hiddenField.value = section
        this.element.appendChild(hiddenField)
      })
    }
  }
}
