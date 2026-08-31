<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<<<<<<< HEAD
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
=======

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">

    <title>CarVerse | Find your drive</title>

    <link rel="stylesheet" href="assets/css/carverse.css">
</head>

<body>

    <nav class="nav">
        <div class="shell">

            <a class="brand" href="index.jsp">CARVERSE</a>

            <div class="navlinks">
                <a class="active" href="index.jsp">Explore</a>
                <a href="car-search.jsp">New Cars</a>
                <a href="compare.jsp">Compare</a>
                <a href="#ownership">Ownership</a>
            </div>

            <%
                String userName = (String) session.getAttribute("USERNAME");
                String userId = (String) session.getAttribute("USERID");

                if (userName == null || userId == null) {
            %>

                <!-- User is not logged in -->
                <a class="btn btn-outline" href="login.jsp">Sign in</a>

                <a class="btn btn-primary" href="user_registration.html">
                    Sign up →
                </a>

            <%
                } else {
            %>

                <!-- Logged-in user -->
                <span class="user-name">
                    Welcome, <%= userName %>
                </span>

            <%
                }
            %>

            <!-- Book Maintenance Button -->
            <a class="btn btn-primary" href="Book_maintenance.jsp">
                Book Maintenance →
            </a>

        </div>
    </nav>


    <main>

        <!-- HERO SECTION -->

        <section class="hero">
            <div class="shell">

                <div class="eyebrow">
                    Find the drive that fits you
                </div>

                <h1>
                    YOUR NEXT CAR.<br>
                    <em>ZERO GUESSWORK.</em>
                </h1>

                <p>
                    Explore honest details, compare the cars that matter,
                    and reserve your favourite with confidence.
                </p>

                <div class="hero-actions">

                    <a class="btn btn-primary" href="car-search.jsp">
                        Explore cars →
                    </a>

                    <a class="btn btn-outline" href="compare.jsp">
                        Compare models
                    </a>

                </div>

            </div>
        </section>


        <!-- SEARCH PANEL -->

        <div class="shell search-panel">

            <strong>Find your perfect match</strong>

            <div class="field grow">
                ⌕ Search brand, model or body type
            </div>

            <div class="field">
                Budget: Any
            </div>

            <a class="btn btn-primary" href="car-search.jsp">
                Search →
            </a>

        </div>


        <!-- POPULAR CARS -->

        <section class="section" id="models">

            <div class="shell">

                <div class="section-head">

                    <div>

                        <div class="eyebrow">
                            Popular right now
                        </div>

                        <h2>Made for your everyday.</h2>

                    </div>

                    <a class="btn btn-outline" href="car-search.jsp">
                        Browse all cars →
                    </a>

                </div>


                <div class="cards">

                    <a class="car-card" href="car-details.jsp">

                        <img
                            src="https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?auto=format&fit=crop&w=700&q=80"
                            alt="Silver sports car"
                        >

                        <div class="content">

                            <span class="tag">Electric sedan</span>

                            <h3>Mahindra XUV.e9</h3>

                            <div class="price">
                                From ₹21.90 Lakh*
                            </div>

                            <div class="specs">

                                <span>⚡ 656 km range</span>
                                <span>5 seats</span>
                                <span>Auto</span>

                            </div>

                        </div>

                    </a>


                    <a class="car-card" href="car-details.jsp">

                        <img
                            src="https://images.unsplash.com/photo-1502877338535-766e1452684a?auto=format&fit=crop&w=700&q=80"
                            alt="Modern SUV"
                        >

                        <div class="content">

                            <span class="tag">Premium SUV</span>

                            <h3>Tata Harrier EV</h3>

                            <div class="price">
                                From ₹24.99 Lakh*
                            </div>

                            <div class="specs">

                                <span>⚡ 627 km range</span>
                                <span>5 seats</span>
                                <span>Auto</span>

                            </div>

                        </div>

                    </a>


                    <a class="car-card" href="car-details.jsp">

                        <img
                            src="https://images.unsplash.com/photo-1552519507-da3b142c6e3d?auto=format&fit=crop&w=700&q=80"
                            alt="Red performance car"
                        >

                        <div class="content">

                            <span class="tag">Performance</span>

                            <h3>Hyundai IONIQ 5</h3>

                            <div class="price">
                                From ₹46.05 Lakh*
                            </div>

                            <div class="specs">

                                <span>⚡ 631 km range</span>
                                <span>5 seats</span>
                                <span>Auto</span>

                            </div>

                        </div>

                    </a>

                </div>

            </div>

        </section>


        <!-- COMPARE SECTION -->

        <section class="compare-strip">

            <div class="shell">

                <div class="eyebrow">
                    Side by side, made simple
                </div>

                <h2>Choose with clarity.</h2>

                <p>
                    Put three favourites head-to-head and reveal the details
                    that make the difference.
                </p>


                <div class="compare-grid">

                    <div>

                        <a class="btn btn-primary" href="compare.jsp">
                            Build a comparison →
                        </a>

                    </div>


                    <div class="mini">
                        <b>Price</b>
                        Ex-showroom & on-road
                    </div>


                    <div class="mini">
                        <b>Range</b>
                        Real-world efficiency
                    </div>


                    <div class="mini">
                        <b>Safety</b>
                        Features & ratings
                    </div>

                </div>

            </div>

        </section>


        <!-- OWNERSHIP SECTION -->

        <section class="section" id="ownership">

            <div class="shell">

                <div class="flow">

                    <div>

                        <div class="eyebrow">
                            Your ownership journey
                        </div>

                        <h2>
                            Everything after “I choose this one.”
                        </h2>

                        <p class="sub">
                            The experience follows your DFD: browse and compare,
                            book and pay, then stay on top of service, feedback
                            and cancellation requests.
                        </p>

                        <a class="btn btn-dark" href="login.jsp">
                            Access my garage →
                        </a>

                    </div>


                    <div class="flow-list">

                        <div class="flow-item">
                            01. Car discovery
                        </div>

                        <div class="flow-item">
                            02. Compare specs
                        </div>

                        <div class="flow-item">
                            03. Booking & payment
                        </div>

                        <div class="flow-item">
                            04. Service & feedback
                        </div>

                    </div>

                </div>

            </div>

        </section>

    </main>


    <!-- FOOTER -->

    <footer class="footer">

        <div class="shell">

            <div>

                <a class="brand" href="index.jsp">
                    CARVERSE
                </a>

                <p>
                    Drive your next decision with confidence.
                </p>

            </div>


            <div>
                Explore · Compare · Book · Maintenance · Support
            </div>


            <div>
                © 2026 CarVerse
            </div>

        </div>

    </footer>


    <div class="toast"></div>

    <script src="assets/js/carverse.js"></script>

</body>
>>>>>>> b51a4db214ced1f8ed6015c2acb5ba4dc3ec6126
</html>