<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Search cars | CarVerse</title>
    <link rel="stylesheet" href="assets/css/carverse.css">
  </head>
  <body>
    <nav class="nav"><div class="shell"><a class="brand" href="index.jsp">CARVERSE</a><div class="navlinks"><a href="index.jsp">Explore</a><a class="active" href="car-search.jsp">New Cars</a><a href="compare.jsp">Compare</a><a href="index.jsp#ownership">Ownership</a></div><a href="login.jsp">Sign in</a><a class="btn btn-primary" href="user_registration.html">Get started →</a></div></nav>
    <main class="search-page">
      <div class="shell">
        <div class="breadcrumbs"><a href="index.jsp">Home</a><span>/</span> New cars</div>
        <section class="search-heading">
          <div><div class="eyebrow">New car discovery</div><h1>Find a car that feels <em>right.</em></h1><p>Explore new cars, compare key essentials and find offers for your city.</p></div>
          <div class="search-count"><strong>48</strong><span>cars matched</span></div>
        </section>
        <section class="search-query" aria-label="Search cars">
          <form id="car-search-form" class="search-form">
            <label class="search-input"><span>⌕</span><input name="query" type="search" placeholder="Search by brand, model or body type" aria-label="Search by brand, model or body type"></label>
            <select name="budget" aria-label="Budget"><option value="">Any budget</option><option>Under ₹10 Lakh</option><option>₹10 - ₹20 Lakh</option><option>₹20 - ₹35 Lakh</option><option>Above ₹35 Lakh</option></select>
            <button class="btn btn-primary" type="submit">Search cars →</button>
          </form>
          <p class="servlet-note"><span>↗</span> Client request point: selected query and filters will be sent to <code>/car-search</code> servlet here.</p>
        </section>
        <div class="results-toolbar"><div><strong>New cars in India</strong><span id="filter-summary"> Showing popular picks</span></div><label class="sort-control">Sort by <select id="sort-results"><option>Popularity</option><option>Price: Low to High</option><option>Price: High to Low</option><option>Newest first</option></select></label></div>
        <div class="search-layout">
          <aside class="filter-panel" aria-label="Filter cars">
            <div class="filter-title"><strong>Filters</strong><button id="clear-filters" type="button">Clear all</button></div>
            <details open><summary>Budget</summary><label><input type="checkbox" name="budget-filter" value="Under ₹10 Lakh"> Under ₹10 Lakh</label><label><input type="checkbox" name="budget-filter" value="₹10 - ₹20 Lakh"> ₹10 - ₹20 Lakh</label><label><input type="checkbox" name="budget-filter" value="₹20 - ₹35 Lakh"> ₹20 - ₹35 Lakh</label><label><input type="checkbox" name="budget-filter" value="Above ₹35 Lakh"> Above ₹35 Lakh</label></details>
            <details open><summary>Body type</summary><label><input type="checkbox" name="body" value="SUV"> SUV</label><label><input type="checkbox" name="body" value="Hatchback"> Hatchback</label><label><input type="checkbox" name="body" value="Sedan"> Sedan</label><label><input type="checkbox" name="body" value="MUV"> MUV</label></details>
            <details><summary>Fuel type</summary><label><input type="checkbox" name="fuel" value="Petrol"> Petrol</label><label><input type="checkbox" name="fuel" value="Electric"> Electric</label><label><input type="checkbox" name="fuel" value="Hybrid"> Hybrid</label></details>
            <details><summary>Transmission</summary><label><input type="checkbox" name="transmission" value="Automatic"> Automatic</label><label><input type="checkbox" name="transmission" value="Manual"> Manual</label></details>
          </aside>
          <section class="result-area" aria-live="polite">
            <div class="active-chips"><button type="button" class="filter-chip">SUV <span>×</span></button><button type="button" class="filter-chip">Automatic <span>×</span></button></div>
            <div class="search-results" id="search-results">
              <article class="result-card" data-name="Mahindra XUV.e9" data-price="21.9"><a class="result-image" href="car-details.jsp"><img src="https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?auto=format&fit=crop&w=900&q=80" alt="Mahindra XUV.e9"><span class="image-label">Electric</span></a><div class="result-content"><div class="result-title"><div><h2><a href="car-details.jsp">Mahindra XUV.e9</a></h2><p>Electric coupe SUV · 5 seats</p></div><button class="heart" aria-label="Save Mahindra XUV.e9">♡</button></div><div class="card-price">₹21.90 - 30.50 Lakh<sup>*</sup></div><p class="emi">Est. EMI ₹44,170 / month</p><div class="result-specs"><span>⚡ 656 km range</span><span>79 kWh</span><span>Automatic</span></div><div class="card-actions"><a href="car-details.jsp">View details →</a><a href="car-details.jsp#offers">Get offers</a></div></div></article>
              <article class="result-card" data-name="Tata Harrier EV" data-price="24.99"><a class="result-image" href="car-details.jsp"><img src="https://images.unsplash.com/photo-1502877338535-766e1452684a?auto=format&fit=crop&w=900&q=80" alt="Tata Harrier EV"><span class="image-label">New launch</span></a><div class="result-content"><div class="result-title"><div><h2><a href="car-details.jsp">Tata Harrier EV</a></h2><p>Electric SUV · 5 seats</p></div><button class="heart" aria-label="Save Tata Harrier EV">♡</button></div><div class="card-price">₹24.99 - 28.99 Lakh<sup>*</sup></div><p class="emi">Est. EMI ₹50,390 / month</p><div class="result-specs"><span>⚡ 627 km range</span><span>75 kWh</span><span>Automatic</span></div><div class="card-actions"><a href="car-details.jsp">View details →</a><a href="car-details.jsp#offers">Get offers</a></div></div></article>
              <article class="result-card" data-name="Hyundai Creta Electric" data-price="17.99"><a class="result-image" href="car-details.jsp"><img src="https://images.unsplash.com/photo-1552519507-da3b142c6e3d?auto=format&fit=crop&w=900&q=80" alt="Hyundai Creta Electric"><span class="image-label">Popular</span></a><div class="result-content"><div class="result-title"><div><h2><a href="car-details.jsp">Hyundai Creta Electric</a></h2><p>Electric SUV · 5 seats</p></div><button class="heart" aria-label="Save Hyundai Creta Electric">♡</button></div><div class="card-price">₹17.99 - 24.38 Lakh<sup>*</sup></div><p class="emi">Est. EMI ₹36,290 / month</p><div class="result-specs"><span>⚡ 473 km range</span><span>51.4 kWh</span><span>Automatic</span></div><div class="card-actions"><a href="car-details.jsp">View details →</a><a href="car-details.jsp#offers">Get offers</a></div></div></article>
              <article class="result-card" data-name="Kia Seltos" data-price="11.19"><a class="result-image" href="car-details.jsp"><img src="https://images.unsplash.com/photo-1542282088-72c9c27ed0cd?auto=format&fit=crop&w=900&q=80" alt="Kia Seltos"><span class="image-label">Petrol</span></a><div class="result-content"><div class="result-title"><div><h2><a href="car-details.jsp">Kia Seltos</a></h2><p>Mid-size SUV · 5 seats</p></div><button class="heart" aria-label="Save Kia Seltos">♡</button></div><div class="card-price">₹11.19 - 20.51 Lakh<sup>*</sup></div><p class="emi">Est. EMI ₹22,580 / month</p><div class="result-specs"><span>17.0 kmpl</span><span>1497 cc</span><span>Manual / Auto</span></div><div class="card-actions"><a href="car-details.jsp">View details →</a><a href="car-details.jsp#offers">Get offers</a></div></div></article>
            </div>
            <nav class="pagination" aria-label="Search results pages"><button class="page-arrow" disabled aria-label="Previous page">←</button><button class="page active" aria-current="page">1</button><button class="page">2</button><button class="page">3</button><span>…</span><button class="page">12</button><button class="page-arrow" aria-label="Next page">→</button></nav>
          </section>
        </div>
      </div>
    </main>
    <footer class="footer"><div class="shell"><div><a class="brand" href="index.jsp">CARVERSE</a><p>Drive your next decision with confidence.</p></div><div>Explore · Compare · Book · Maintenance · Support</div><div>© 2026 CarVerse</div></div></footer>
    <script src="assets/js/carverse.js"></script>
  </body>
</html>
