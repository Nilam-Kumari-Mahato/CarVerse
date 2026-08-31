package com.importer;

import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.Map;
import java.util.regex.Pattern;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

public class CarDataImporter {

    private static final HttpClient HTTP_CLIENT = HttpClient.newHttpClient();

    public static void main(String[] args) {

        try {
            // ---------------------------------------------------------
            // 1. Read command-line arguments
            // ---------------------------------------------------------

            String brand = args.length > 0 ? args[0] : null;
            String limitArgument = args.length > 1 ? args[1] : "10";

            int limit;

            try {
                limit = Integer.parseInt(limitArgument);
            } catch (NumberFormatException e) {
                throw new RuntimeException(
                        "Limit must be a valid integer."
                );
            }

            if (brand == null || brand.isBlank() || limit < 1) {
                throw new RuntimeException(
                        "Usage: CarDataImporter <brand> [limit]"
                );
            }

            // ---------------------------------------------------------
            // 2. Read environment variables
            // ---------------------------------------------------------

            String apiBaseUrl = System.getenv("CAR_API_BASE_URL");
            String apiKey = System.getenv("X-API-Key");

            String dbConnectString = System.getenv("DB_CONNECT_STRING");
            String dbUser = System.getenv("DB_USER");
            String dbPassword = System.getenv("DB_PASSWORD");

            String carIdSequence = System.getenv("CAR_ID_SEQUENCE");

            if (carIdSequence == null || carIdSequence.isBlank()) {
                carIdSequence = "CAR_DETAILS_SEQ";
            }

            if (apiBaseUrl == null || apiBaseUrl.isBlank()) {
                throw new RuntimeException(
                        "CAR_API_BASE_URL must be set."
                );
            }

            if (dbConnectString == null || dbConnectString.isBlank()
                    || dbUser == null || dbUser.isBlank()
                    || dbPassword == null || dbPassword.isBlank()) {

                throw new RuntimeException(
                        "DB_CONNECT_STRING, DB_USER, and DB_PASSWORD must be set."
                );
            }

            // Validate sequence name before putting it into SQL.
            if (!Pattern.matches(
                    "^[A-Za-z][A-Za-z0-9_$#]*$",
                    carIdSequence)) {

                throw new RuntimeException(
                        "CAR_ID_SEQUENCE must be a valid Oracle identifier."
                );
            }

            // ---------------------------------------------------------
            // 3. Get models for the selected brand
            // ---------------------------------------------------------

            JsonObject modelsResponse = getApiData(
                    apiBaseUrl,
                    apiKey,
                    "get_brand_models",
                    Map.of(
                            "brand", brand,
                            "limit", String.valueOf(limit)
                    )
            );

            JsonArray models = getRequiredArray(
                    modelsResponse,
                    "models"
            );

            String responseBrand = getString(
                    modelsResponse,
                    "brand"
            );

            if (responseBrand == null || responseBrand.isBlank()) {
                responseBrand = brand;
            }

            System.out.println(
                    "Found " + models.size()
                    + " model(s) for " + responseBrand
            );

            // ---------------------------------------------------------
            // 4. Load Oracle JDBC driver
            // ---------------------------------------------------------

            Class.forName("oracle.jdbc.driver.OracleDriver");

            // ---------------------------------------------------------
            // 5. Connect to Oracle
            // ---------------------------------------------------------

            try (Connection connection = DriverManager.getConnection(
                    dbConnectString,
                    dbUser,
                    dbPassword)) {

                connection.setAutoCommit(false);

                String insertSql =
                        "INSERT INTO car_details ("
                        + "car_id, model_name, brand, body_type, price_range, "
                        + "fuel_types, mileage, engine, power, torque, "
                        + "seating_capacity, drive_type, "
                        + "safety_rating, length, width, height, "
                        + "boot_space, wheelbase, features, images, source_url"
                        + ") VALUES ("
                        + carIdSequence + ".NEXTVAL, "
                        + "?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "
                        + "?, ?, ?, ?, ?, ?, ?, ?, ?, ?"
                        + ")";

                try (PreparedStatement statement =
                             connection.prepareStatement(insertSql)) {

                    try {
                        // -------------------------------------------------
                        // 6. Process every model
                        // -------------------------------------------------

                        for (JsonElement modelElement : models) {

                            JsonObject model =
                                    modelElement.getAsJsonObject();

                            String modelSlug =
                                    getString(model, "model_slug");

                            if (modelSlug == null || modelSlug.isBlank()) {
                                System.out.println(
                                        "Skipping model because model_slug is missing."
                                );
                                continue;
                            }

                            // -------------------------------------------------
                            // 7. Get detailed information for this model
                            // -------------------------------------------------

                            JsonObject details = getApiData(
                                    apiBaseUrl,
                                    apiKey,
                                    "get_model_details",
                                    Map.of(
                                            "brand", responseBrand,
                                            "model", modelSlug
                                    )
                            );

                            // -------------------------------------------------
                            // 8. Extract JSON sections
                            // -------------------------------------------------

                            JsonObject specs =
                                    getObject(details, "engine_specs");

                            JsonObject dimensions =
                                    getObject(details, "dimensions");

                            // -------------------------------------------------
                            // 9. Extract values
                            // -------------------------------------------------

                            String modelName =
                                    fit(
                                            getString(details, "model_name"),
                                            100,
                                            "MODEL_NAME"
                                    );

                            String detailBrand =
                                    fit(
                                            getString(details, "brand"),
                                            50,
                                            "BRAND"
                                    );

                            String bodyType =
                                    fit(
                                            getString(details, "body_type"),
                                            50,
                                            "BODY_TYPE"
                                    );

                            String priceRange =
                                    fit(
                                            getString(details, "price_range"),
                                            100,
                                            "PRICE_RANGE"
                                    );

                            String fuelTypes =
                                    fit(
                                            commaSeparated(
                                                    getElement(details, "fuel_types")
                                            ),
                                            500,
                                            "FUEL_TYPES"
                                    );

                            String mileage =
                                    fit(
                                            getString(details, "mileage"),
                                            50,
                                            "MILEAGE"
                                    );

                            String engine =
                                    fit(
                                            getString(specs, "engine"),
                                            100,
                                            "ENGINE"
                                    );

                            String power =
                                    fit(
                                            getString(specs, "power"),
                                            100,
                                            "POWER"
                                    );

                            String torque =
                                    fit(
                                            getString(specs, "torque"),
                                            100,
                                            "TORQUE"
                                    );

                            String seatingCapacity =
                                    fit(
                                            getString(specs, "seating_capacity"),
                                            20,
                                            "SEATING_CAPACITY"
                                    );

                            String driveType =
                                    fit(
                                            getString(specs, "drive_type"),
                                            50,
                                            "DRIVE_TYPE"
                                    );

                            
                            String safetyRating =
                                    fit(
                                            getString(details, "safety_rating"),
                                            50,
                                            "SAFETY_RATING"
                                    );

                            String length =
                                    fit(
                                            getString(dimensions, "length"),
                                            50,
                                            "LENGTH"
                                    );

                            String width =
                                    fit(
                                            getString(dimensions, "width"),
                                            50,
                                            "WIDTH"
                                    );

                            String height =
                                    fit(
                                            getString(dimensions, "height"),
                                            50,
                                            "HEIGHT"
                                    );

                            String bootSpace =
                                    fit(
                                            getString(dimensions, "boot_space"),
                                            50,
                                            "BOOT_SPACE"
                                    );

                            String wheelbase =
                                    fit(
                                            getString(dimensions, "wheelbase"),
                                            50,
                                            "WHEELBASE"
                                    );

                            String features =
                                    fit(
                                            commaSeparated(
                                                    getElement(details, "features")
                                            ),
                                            4000,
                                            "FEATURES"
                                    );

                            String images =
                                    fit(
                                            commaSeparated(
                                                    getElement(details, "images")
                                            ),
                                            4000,
                                            "IMAGES"
                                    );

                            String sourceUrl =
                                    fit(
                                            getString(details, "url"),
                                            500,
                                            "SOURCE_URL"
                                    );

                            // -------------------------------------------------
                            // 10. Bind values to INSERT statement
                            // -------------------------------------------------

                            statement.setString(1, modelName);
                            statement.setString(2, detailBrand);
                            statement.setString(3, bodyType);
                            statement.setString(4, priceRange);
                            statement.setString(5, fuelTypes);
                            statement.setString(6, mileage);
                            statement.setString(7, engine);
                            statement.setString(8, power);
                            statement.setString(9, torque);
                            statement.setString(10, seatingCapacity);
                            statement.setString(11, driveType);
                            statement.setString(12, safetyRating);
                            statement.setString(13, length);
                            statement.setString(14, width);
                            statement.setString(15, height);
                            statement.setString(16, bootSpace);
                            statement.setString(17, wheelbase);
                            statement.setString(18, features);
                            statement.setString(19, images);
                            statement.setString(20, sourceUrl);

                            // -------------------------------------------------
                            // 11. Execute INSERT
                            // -------------------------------------------------

                            statement.executeUpdate();

                            System.out.println(
                                    "Inserted " + modelName
                            );
                        }

                        // -------------------------------------------------
                        // 12. Commit everything
                        // -------------------------------------------------

                        connection.commit();

                        System.out.println(
                                "Imported "
                                + models.size()
                                + " "
                                + responseBrand
                                + " model(s)."
                        );

                    } catch (Exception e) {

                        // If anything fails, undo all inserts.
                        connection.rollback();

                        throw e;
                    }
                }
            }

        } catch (Exception e) {

            System.err.println(
                    "Import failed: " + e.getMessage()
            );

            e.printStackTrace();

        }
    }

    // ================================================================
    // API REQUEST
    // ================================================================

    private static JsonObject getApiData(
            String apiBaseUrl,
            String apiKey,
            String path,
            Map<String, String> parameters)
            throws IOException, InterruptedException {

        URI uri = buildEndpoint(
                apiBaseUrl,
                path,
                parameters
        );
        
        System.out.println("API Request: " + uri);

        HttpRequest.Builder requestBuilder =
                HttpRequest.newBuilder()
                        .uri(uri)
                        .GET();

        if (apiKey != null && !apiKey.isBlank()) {
            requestBuilder.header(
                    "X-API-Key",
                    apiKey
            );
        }

        HttpRequest request =
                requestBuilder.build();

        HttpResponse<String> response =
                HTTP_CLIENT.send(
                        request,
                        HttpResponse.BodyHandlers.ofString()
                );

        if (response.statusCode() < 200
                || response.statusCode() >= 300) {

            throw new RuntimeException(
                    path
                    + " returned HTTP "
                    + response.statusCode()
                    + "\nResponse body: "
                    + response.body()
            );
        }

        JsonObject payload =
                JsonParser.parseString(
                        response.body()
                ).getAsJsonObject();

        String status =
                getString(payload, "status");

        JsonElement data =
                getElement(payload, "data");

        if (!"success".equals(status)
                || data == null
                || data.isJsonNull()) {

            throw new RuntimeException(
                    path
                    + " returned an unsuccessful payload: "
                    + response.body()
            );
        }

        return data.getAsJsonObject();
    }

    // ================================================================
    // BUILD API URL
    // ================================================================

    private static URI buildEndpoint(
            String apiBaseUrl,
            String path,
            Map<String, String> parameters) {

        String base =
                apiBaseUrl.endsWith("/")
                        ? apiBaseUrl
                        : apiBaseUrl + "/";

        StringBuilder url =
                new StringBuilder(
                        base + path
                );

        boolean first = true;

        for (Map.Entry<String, String> entry :
                parameters.entrySet()) {

            url.append(first ? "?" : "&");

            url.append(
                    URLEncoder.encode(
                            entry.getKey(),
                            StandardCharsets.UTF_8
                    )
            );

            url.append("=");

            url.append(
                    URLEncoder.encode(
                            entry.getValue(),
                            StandardCharsets.UTF_8
                    )
            );

            first = false;
        }

        return URI.create(url.toString());
    }

    // ================================================================
    // JSON HELPERS
    // ================================================================

    private static JsonElement getElement(
            JsonObject object,
            String name) {

        if (object == null
                || !object.has(name)
                || object.get(name).isJsonNull()) {

            return null;
        }

        return object.get(name);
    }

    private static String getString(
            JsonObject object,
            String name) {

        JsonElement element =
                getElement(object, name);

        if (element == null) {
            return null;
        }

        if (element.isJsonPrimitive()) {
            return element.getAsString();
        }

        return element.toString();
    }

    private static JsonObject getObject(
            JsonObject object,
            String name) {

        JsonElement element =
                getElement(object, name);

        if (element != null
                && element.isJsonObject()) {

            return element.getAsJsonObject();
        }

        return new JsonObject();
    }

    private static JsonArray getRequiredArray(
            JsonObject object,
            String name) {

        JsonElement element =
                getElement(object, name);

        if (element == null
                || !element.isJsonArray()) {

            throw new RuntimeException(
                    "API response does not contain a "
                    + name
                    + " array."
            );
        }

        return element.getAsJsonArray();
    }

    // ================================================================
    // ARRAY → COMMA-SEPARATED STRING
    // ================================================================

    private static String commaSeparated(
            JsonElement value) {

        if (value == null
                || value.isJsonNull()) {

            return null;
        }

        if (value.isJsonArray()) {

            StringBuilder result =
                    new StringBuilder();

            JsonArray array =
                    value.getAsJsonArray();

            for (JsonElement element : array) {

                if (element == null
                        || element.isJsonNull()) {
                    continue;
                }

                String text =
                        element.getAsString();

                if (text == null
                        || text.isBlank()) {
                    continue;
                }

                if (result.length() > 0) {
                    result.append(", ");
                }

                result.append(text);
            }

            return result.length() == 0
                    ? null
                    : result.toString();
        }

        return value.getAsString();
    }

    // ================================================================
    // NULL / LENGTH HANDLING
    // ================================================================

    private static String valueOrNull(
            String value) {

        if (value == null
                || value.isEmpty()) {

            return null;
        }

        return value;
    }

    private static String fit(
            String value,
            int maxLength,
            String column) {

        String text =
                valueOrNull(value);

        if (text != null
                && text.length() > maxLength) {

            throw new RuntimeException(
                    column
                    + " is "
                    + text.length()
                    + " characters; CAR_DETAILS allows "
                    + maxLength
            );
        }

        return text;
    }
}