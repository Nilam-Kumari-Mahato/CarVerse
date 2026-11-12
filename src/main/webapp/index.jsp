<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.util.ArrayList, java.util.List" %>
<%@ page import="com.servlet.CarModel" %>

<%
    List<CarModel> popularCars = new ArrayList<>();
    String dbUser = System.getenv("DB_USER");
    if (dbUser == null || dbUser.trim().isEmpty()) dbUser = "CARVERSE";
    String dbPass = System.getenv("DB_PASSWORD");
    if (dbPass == null || dbPass.trim().isEmpty()) dbPass = "manager";

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        try (Connection con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:XE", dbUser, dbPass);
             PreparedStatement ps = con.prepareStatement(
                "SELECT car_id, model_name, brand, body_type, price_range, "
              + "fuel_types, mileage, seating_capacity, images "
              + "FROM (SELECT car_id, model_name, brand, body_type, price_range, "
              + "fuel_types, mileage, seating_capacity, images "
              + "FROM car_details ORDER BY car_id) WHERE ROWNUM <= 3");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                CarModel car = new CarModel();
                car.setCarId(rs.getInt("car_id"));
                car.setModelName(rs.getString("model_name"));
                car.setBrand(rs.getString("brand"));
                car.setBodyType(rs.getString("body_type"));
                car.setPriceRange(rs.getString("price_range"));
                car.setFuelTypes(rs.getString("fuel_types"));
                car.setMileage(rs.getString("mileage"));
                car.setSeatingCapacity(rs.getString("seating_capacity"));
                car.setImages(rs.getString("images"));
                popularCars.add(car);
            }
        }
    } catch (Exception e) {
        application.log("Unable to load popular cars for the home page.", e);
    }
%>

<%! private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;").replace("<", "&lt;")
                    .replace(">", "&gt;").replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">

    <title>CarVerse | Find your drive</title>

    <link rel="stylesheet" href="assets/css/common.css">
    <link rel="stylesheet" href="assets/css/home.css">
</head>

<body>

    <%@ include file="/WEB-INF/jspf/customer-nav.jspf" %>


    <main>

        <!-- HERO SECTION -->

        <section class="hero" id="hero">
            <div class="shell">

                <div class="hero-copy">
                    <div class="eyebrow">Find the drive that fits you</div>

                    <h1>
                        YOUR NEXT CAR.<br>
                        <em>ZERO GUESSWORK.</em>
                    </h1>

                    <p>
                        Explore honest details, compare the cars that matter,
                        and reserve your favourite with confidence.
                    </p>

                    <div class="hero-actions">
                        <a class="btn btn-primary" href="car-search.jsp">Explore cars →</a>
                        <a class="btn btn-outline" href="compare.jsp">Compare models</a>
                    </div>
                </div>

                <form class="hero-search" action="car-search.jsp" method="get" role="search">
                    <label class="sr-only" for="home-car-search">Search cars</label>
                    <input id="home-car-search" type="search" name="query" placeholder="Search brand, model or body type">
                    <button class="btn btn-primary" type="submit">Search</button>
                </form>

            </div>
        </section>


        <!-- POPULAR CARS -->

        <section class="section" id="models">

            <div class="shell">

                <div class="section-head">
                    <div>
                        <div class="eyebrow">Popular right now</div>
                        <h2>Made for your everyday.</h2>
                    </div>
                    <a class="btn btn-outline" href="car-search.jsp">Browse all cars →</a>
                </div>

                <div class="cards">
                    <% if (!popularCars.isEmpty()) {
                        for (CarModel car : popularCars) {
                            String image = car.getImages();
                            if (image != null && image.contains(",")) image = image.split(",")[0].trim();
                            if (image == null || image.trim().isEmpty()) image = "assets/images/car-placeholder.jpg";
                            String carName = (car.getModelName() == null ? "" : car.getModelName().trim()).trim();
                            String price = car.getPriceRange();
                            if (price == null || price.trim().isEmpty()) price = "Price unavailable";
                            else if (!price.trim().startsWith("₹") && !price.trim().startsWith("Rs")) price = "₹" + price.trim();
                    %>
                        <a class="car-card" href="<%= request.getContextPath() %>/car-details?carId=<%= car.getCarId() %>">
                            <img src="<%= escapeHtml(image) %>" alt="<%= escapeHtml(carName) %>">
                            <div class="content">
                                <span class="tag"><%= escapeHtml(car.getBodyType() == null ? "Car" : car.getBodyType()) %></span>
                                <h3><%= escapeHtml(carName) %></h3>
                                <div class="price"><%= escapeHtml(price) %><sup>*</sup></div>
                                <div class="specs">
                                    <% if (car.getMileage() != null && !car.getMileage().trim().isEmpty()) { %>
                                        <span><%= escapeHtml(car.getMileage()) %></span>
                                    <% } %>
                                    <% if (car.getSeatingCapacity() != null && !car.getSeatingCapacity().trim().isEmpty()) { %>
                                        <span><%= escapeHtml(car.getSeatingCapacity()) %> seats</span>
                                    <% } %>
                                    <% if (car.getFuelTypes() != null && !car.getFuelTypes().trim().isEmpty()) { %>
                                        <span><%= escapeHtml(car.getFuelTypes()) %></span>
                                    <% } %>
                                </div>
                            </div>
                        </a>
                    <%  }
                    } else { %>
                        <p class="empty-cars">Car details are currently unavailable.</p>
                    <% } %>
                </div>

            </div>

        </section>


        <!-- COMPARE SECTION -->

        <section class="compare-strip" id="compare">

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
                    <div class="compare-intro">
                        <a class="btn btn-primary" href="compare.jsp">Build a comparison →</a>
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

                    <div class="compare-visual">
                        <img src="assets/images/car-compare.png" alt="Two cars side by side">
                    </div>
                </div>

            </div>

        </section>


        <!-- CAR MAINTENANCE SECTION -->

        <section class="section" id="maintenance">

            <div class="shell">

                <div class="flow">

                    <div>

                        <div class="eyebrow">Car maintenance</div>

                        <h2>
                            Everything your car needs, today and later.
                        </h2>

                        <p class="sub">
                            Book a service, keep track of maintenance, and stay
                            on top of your car’s care — all in one place.
                        </p>

                        <a class="btn btn-dark" href="Book_maintenance.jsp">
                            Book maintenance →
                        </a>

                    </div>


                    <div class="flow-list">

                        <div class="flow-item">Schedule a service</div>

                        <div class="flow-item">Track service history</div>

                        <div class="flow-item">Maintenance updates</div>

                        <div class="flow-item">Feedback & support</div>

                    </div>

                </div>

            </div>

        </section>

    </main>


    <!-- FOOTER -->

    <%@ include file="/WEB-INF/jspf/customer-footer.jspf" %>


    <div class="toast"></div>

    <script src="assets/js/carverse.js"></script>

</body>
</html>
