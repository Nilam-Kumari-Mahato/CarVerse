document.querySelectorAll('[data-toast]').forEach((button) => {
  button.addEventListener('click', () => {
    const toast = document.querySelector('.toast');

    toast.textContent = button.dataset.toast;
    toast.style.display = 'block';

    setTimeout(() => {
      toast.style.display = 'none';
    }, 3000);
  });
});

const searchForm = document.querySelector('#car-search-form');

if (searchForm) {
  const results = [...document.querySelectorAll('.result-card')];
  const filterSummary = document.querySelector('#filter-summary');
  const sortControl = document.querySelector('#sort-results');

  searchForm.addEventListener('submit', (event) => {
    event.preventDefault();
    const data = new FormData(searchForm);
    const term = (data.get('query') || '').toLowerCase().trim();

    // CLIENT → SERVLET REQUEST BOUNDARY:
    // Replace this local preview with fetch('car-search', { method: 'GET', ... })
    // once the CarSearch servlet is ready to return live search results.
    const selectedFilters = [...document.querySelectorAll('.filter-panel input:checked')]
      .map((input) => input.value);
    const visible = results.filter((card) => card.dataset.name.toLowerCase().includes(term) || !term);
    results.forEach((card) => {
      card.hidden = !visible.includes(card);
    });
    filterSummary.textContent = term ? ` • Results for “${data.get('query')}”` : selectedFilters.length ? ` • ${selectedFilters.join(', ')}` : ' • Showing popular picks';
  });

  sortControl.addEventListener('change', () => {
    const ordered = [...results].sort((a, b) => {
      const priceDifference = Number(a.dataset.price) - Number(b.dataset.price);
      return sortControl.value === 'Price: High to Low' ? -priceDifference : priceDifference;
    });
    if (sortControl.value.includes('Price')) {
      ordered.forEach((card) => card.parentElement.append(card));
    }
  });

  document.querySelector('#clear-filters').addEventListener('click', () => {
    document.querySelectorAll('.filter-panel input').forEach((input) => { input.checked = false; });
    document.querySelectorAll('.active-chips').forEach((chips) => { chips.innerHTML = ''; });
  });

  document.querySelectorAll('.filter-panel input').forEach((input) => {
    input.addEventListener('change', () => {
      const values = [...document.querySelectorAll('.filter-panel input:checked')].map((filter) => filter.value);
      const chips = document.querySelector('.active-chips');
      chips.innerHTML = values.map((value) => `<button type="button" class="filter-chip">${value} <span>×</span></button>`).join('');
      filterSummary.textContent = values.length ? ` • ${values.join(', ')}` : ' • Showing popular picks';
    });
  });
}
