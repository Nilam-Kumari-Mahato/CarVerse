<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Compare cars | CarVerse</title>
    <link rel="stylesheet" href="assets/css/carverse.css">
  </head>
  <body>
    <nav class="nav">
      <div class="shell">
        <a class="brand" href="index.jsp">CARVERSE</a>
        <div class="navlinks">
          <a href="index.jsp">Explore</a>
          <a href="car-search.jsp">New Cars</a>
          <a class="active" href="compare.jsp">Compare</a>
          <a href="index.jsp#ownership">Ownership</a>
        </div>
        <a href="login.jsp">Sign in</a>
        <a class="btn btn-primary" href="user_registration.html">Get started →</a>
      </div>
    </nav>
    <section class="compare-top">
      <div class="shell">
        <div class="eyebrow">Car comparison</div>
        <h1 style="font-size:42px;margin:8px 0">Three cars. One confident choice.</h1>
        <p>Compare the features that matter before you reserve.</p>
        <div class="compare-cars">
          <article class="compare-car">
            <img src="https://images.unsplash.com/photo-1502877338535-766e1452684a?auto=format&fit=crop&w=700&q=80" alt="SUV">
            <div>
              <b>Tata Harrier EV</b>
              <br>
              <span class="tag">₹24.99 Lakh*</span>
            </div>
          </article>
          <article class="compare-car">
            <img src="https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?auto=format&fit=crop&w=700&q=80" alt="Sedan">
            <div>
              <b>Mahindra XUV.e9</b>
              <br>
              <span class="tag">₹21.90 Lakh*</span>
            </div>
          </article>
          <article class="compare-car">
            <img src="https://images.unsplash.com/photo-1552519507-da3b142c6e3d?auto=format&fit=crop&w=700&q=80" alt="Car">
            <div>
              <b>Hyundai IONIQ 5</b>
              <br>
              <span class="tag">₹46.05 Lakh*</span>
            </div>
          </article>
        </div>
      </div>
    </section>
    <main class="compare-page">
      <div class="shell">
        <div class="compare-controls">
          <button class="btn btn-primary" data-toast="Comparison saved to your garage.">Save comparison</button>
          <button class="btn btn-outline" data-toast="Only different specifications are now highlighted.">Highlight differences</button>
          <span class="sub">Showing key specifications</span>
        </div>
        <div class="eyebrow">At a glance</div>
        <h2>Key specifications</h2>
        <table class="spec-table">
          <tbody>
            <tr>
              <th>Ex-showroom price</th>
              <td>₹24.99 Lakh*</td>
              <td>₹21.90 Lakh*</td>
              <td>₹46.05 Lakh*</td>
            </tr>
            <tr>
              <th>Powertrain</th>
              <td>Electric SUV</td>
              <td>Electric coupe SUV</td>
              <td>Electric crossover</td>
            </tr>
            <tr>
              <th>Certified range</th>
              <td>627 km</td>
              <td>656 km</td>
              <td>631 km</td>
            </tr>
            <tr>
              <th>Battery capacity</th>
              <td>75 kWh</td>
              <td>79 kWh</td>
              <td>72.6 kWh</td>
            </tr>
            <tr>
              <th>Seating</th>
              <td>5</td>
              <td>5</td>
              <td>5</td>
            </tr>
            <tr>
              <th>Safety rating</th>
              <td>★★★★★</td>
              <td>★★★★★</td>
              <td>★★★★★</td>
            </tr>
          </tbody>
        </table>
        <section class="flow" style="margin-top:38px">
          <div>
            <div class="eyebrow">Ready when you are</div>
            <h2>Book a test drive or reserve online.</h2>
            <p class="sub">Your booking, payment, cancellation request and confirmation remain visible from one account.</p>
          </div>
          <div style="display:grid;place-items:center">
            <a class="btn btn-primary" href="login.jsp">Continue to booking →</a>
          </div>
        </section>
      </div>
    </main>
    <footer class="footer">
      <div class="shell">
        <div>
          <a class="brand" href="index.jsp">CARVERSE</a>
        </div>
        <div>Explore · Compare · Book · Maintenance · Support</div>
        <div>© 2026 CarVerse</div>
      </div>
    </footer>
    <div class="toast">
    </div>
    <script src="assets/js/carverse.js">
    </script>
  </body>
</html>
