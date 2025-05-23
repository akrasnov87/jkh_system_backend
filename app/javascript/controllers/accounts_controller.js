import { Controller } from "@hotwired/stimulus"
import SlimSelect from 'slim-select'
// Connects to data-controller="slim"
export default class extends Controller {
  connect() {
    const csrfToken = () => {
      if (document && document.querySelector) {
        const el = document.querySelector("meta[name='csrf-token']")

        return el?.getAttribute("content") ?? ""
      }

      return ""
    }

    new SlimSelect({
      select: this.element,
      events: {
        search: (search, currentData) => {
          return new Promise((resolve, reject) => {
            if (search.length < 2) {
              return reject('Для поиска нужно больше 2 символов')
            }
            // Fetch random first and last name data
            const url = window.location.host === 'localhost:3000' ? 'http://localhost:3000' : 'https://jkh-system.ru'

            fetch(`${url}/accounts/options.json?number=${search}`, {
              method: 'GET',
              headers: {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Credentials': 'true',
                'X-CSRF-TOKEN': csrfToken()
              },
            })
              .then((response) => response.json())
              .then((data) => {
                console.log(data)
                const options = data
                  .filter((account) => {
                    return !currentData.some((optionData) => {
                      return optionData.value === `${account.value}`
                    })
                  })
                  .map((account) => {
                    return {
                      text: `${account.text}`,
                      value: `${account.value}`,
                    }
                  })

                resolve(options)
              })
          })
        }
      }
    })
  }
}
