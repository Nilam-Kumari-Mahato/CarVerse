import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

protected void doGet(HttpServletRequest request,
        HttpServletResponse response)
throws ServletException, IOException {

String year = request.getParameter("year");
String make = request.getParameter("make");
String model = request.getParameter("model");

if (make == null || make.isBlank()) {
response.sendError(HttpServletResponse.SC_BAD_REQUEST,
   "The 'make' parameter is required.");
return;
}

// Set CARVECTOR_API_KEY as a server environment variable.
String apiKey = System.getenv("CARVECTOR_API_KEY");
if (apiKey == null || apiKey.isBlank()) {
response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
   "CarVector API key is not configured.");
return;
}

StringBuilder url = new StringBuilder("https://api.carvector.io/v1/vehicles");
url.append("?make=").append(URLEncoder.encode(make, StandardCharsets.UTF_8));

if (year != null && !year.isBlank()) {
url.append("&year=").append(URLEncoder.encode(year, StandardCharsets.UTF_8));
}
if (model != null && !model.isBlank()) {
url.append("&model=").append(URLEncoder.encode(model, StandardCharsets.UTF_8));
}

url.append("&limit=10");

try {
HttpClient client = HttpClient.newBuilder()
   .connectTimeout(Duration.ofSeconds(10))
   .build();

HttpRequest apiRequest = HttpRequest.newBuilder()
   .uri(URI.create(url.toString()))
   .timeout(Duration.ofSeconds(20))
   .header("Authorization", "Bearer " + apiKey)
   .header("Accept", "application/json")
   .GET()
   .build();

HttpResponse<String> apiResponse = client.send(
   apiRequest, HttpResponse.BodyHandlers.ofString());

response.setContentType("application/json");
response.setCharacterEncoding("UTF-8");
response.setStatus(apiResponse.statusCode());
response.getWriter().write(apiResponse.body());

} catch (InterruptedException e) {
Thread.currentThread().interrupt();
response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
   "The API request was interrupted.");
} catch (Exception e) {
response.sendError(HttpServletResponse.SC_BAD_GATEWAY,
   "Could not fetch car details.");
}
}