<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<<<<<<< Updated upstream
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CarVerse | Find your drive</title>
    <link rel="stylesheet" href="assets/css/carverse.css">
    <style>.sr-only{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border:0}.navlinks,.specs,.flow-list{list-style:none;margin:0;padding:0}</style>
  </head>
  <body>
    <header class="nav">
      <nav class="shell" aria-label="Primary navigation">
        <a class="brand" href="index.jsp" aria-label="CarVerse home">CARVERSE</a>
        <ul class="navlinks"><li><a class="active" href="index.jsp">Explore</a></li><li><a href="car-search.jsp">New Cars</a></li><li><a href="compare.jsp">Compare</a></li><li><a href="#ownership">Ownership</a></li></ul>
        <a href="login.jsp">Sign in</a><a class="btn btn-primary" href="user_registration.html">Get started <span aria-hidden="true">→</span></a>
      </nav>
    </header>
    <main>
      <section class="hero" aria-labelledby="hero-title"><div class="shell"><p class="eyebrow">Find the drive that fits you</p><h1 id="hero-title">Your next car.<br><em>Zero guesswork.</em></h1><p>Explore honest details, compare the cars that matter, and reserve your favourite with confidence.</p><div class="hero-actions"><a class="btn btn-primary" href="car-search.jsp">Explore cars <span aria-hidden="true">→</span></a><a class="btn btn-outline" href="compare.jsp">Compare models</a></div></div></section>
      <section class="shell search-panel" aria-labelledby="quick-search-title"><h2 id="quick-search-title">Find your perfect match</h2><form class="home-search-form" action="car-search.jsp" method="get" style="display:flex;gap:12px;align-items:center;flex:1"><label class="sr-only" for="home-search">Search by brand, model or body type</label><input class="field grow" id="home-search" name="query" type="search" placeholder="Search brand, model or body type"><label class="sr-only" for="home-budget">Select your budget</label><select class="field" id="home-budget" name="budget"><option value="">Budget: Any</option><option value="under-10">Under ₹10 Lakh</option><option value="10-20">₹10 - ₹20 Lakh</option><option value="20-35">₹20 - ₹35 Lakh</option><option value="above-35">Above ₹35 Lakh</option></select><button class="btn btn-primary" type="submit">Search <span aria-hidden="true">→</span></button></form></section>
      <section class="section" id="models" aria-labelledby="popular-cars-title"><div class="shell"><div class="section-head"><div><p class="eyebrow">Popular right now</p><h2 id="popular-cars-title">Made for your everyday.</h2></div><a class="btn btn-outline" href="car-search.jsp">Browse all cars <span aria-hidden="true">→</span></a></div><div class="cards">
        <article class="car-card"><a href="car-details.jsp"><img src="https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?auto=format&fit=crop&w=700&q=80" alt="Mahindra XUV.e9 electric coupe SUV"></a><div class="content"><p class="tag">Electric sedan</p><h3><a href="car-details.jsp">Mahindra XUV.e9</a></h3><p class="price">From ₹21.90 Lakh<sup>*</sup></p><ul class="specs"><li>⚡ 656 km range</li><li>5 seats</li><li>Auto</li></ul></div></article>
        <article class="car-card"><a href="car-details.jsp"><img src="https://images.unsplash.com/photo-1502877338535-766e1452684a?auto=format&fit=crop&w=700&q=80" alt="Tata Harrier EV premium SUV"></a><div class="content"><p class="tag">Premium SUV</p><h3><a href="car-details.jsp">Tata Harrier EV</a></h3><p class="price">From ₹24.99 Lakh<sup>*</sup></p><ul class="specs"><li>⚡ 627 km range</li><li>5 seats</li><li>Auto</li></ul></div></article>
        <article class="car-card"><a href="car-details.jsp"><img src="https://images.unsplash.com/photo-1552519507-da3b142c6e3d?auto=format&fit=crop&w=700&q=80" alt="Hyundai IONIQ 5 electric crossover"></a><div class="content"><p class="tag">Performance</p><h3><a href="car-details.jsp">Hyundai IONIQ 5</a></h3><p class="price">From ₹46.05 Lakh<sup>*</sup></p><ul class="specs"><li>⚡ 631 km range</li><li>5 seats</li><li>Auto</li></ul></div></article>
      </div></div></section>
      <section class="compare-strip" aria-labelledby="compare-title"><div class="shell"><p class="eyebrow">Side by side, made simple</p><h2 id="compare-title">Choose with clarity.</h2><p>Put three favourites head-to-head and reveal the details that make the difference.</p><div class="compare-grid"><div><a class="btn btn-primary" href="compare.jsp">Build a comparison <span aria-hidden="true">→</span></a></div><div class="mini"><b>Price</b>Ex-showroom &amp; on-road</div><div class="mini"><b>Range</b>Real-world efficiency</div><div class="mini"><b>Safety</b>Features &amp; ratings</div></div></div></section>
      <section class="section" id="ownership" aria-labelledby="ownership-title"><div class="shell"><div class="flow"><div><p class="eyebrow">Your ownership journey</p><h2 id="ownership-title">Everything after “I choose this one.”</h2><p class="sub">The experience follows your DFD: browse and compare, book and pay, then stay on top of service, feedback and cancellation requests.</p><a class="btn btn-dark" href="login.jsp">Access my garage <span aria-hidden="true">→</span></a></div><ol class="flow-list"><li class="flow-item">Car discovery</li><li class="flow-item">Compare specs</li><li class="flow-item">Booking &amp; payment</li><li class="flow-item">Service &amp; feedback</li></ol></div></div></section>
    </main>
    <footer class="footer">
    <div class="shell"><div>
    <a class="brand" href="index.jsp">CARVERSE</a>
    <p>Drive your next decision with confidence.</p>
    </div>
    <nav aria-label="Footer navigation">Explore · Compare · Book · Maintenance · Support</nav>
    <p>© 2026 CarVerse</p>
    </div>
    </footer>
    <div class="toast" role="status" aria-live="polite"></div>
    <script src="assets/js/carverse.js"></script>
     </body>
</html>