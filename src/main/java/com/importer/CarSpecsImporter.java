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
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

public class CarSpecsImporter {

    private static final HttpClient HTTP_CLIENT =
            HttpClient.newHttpClient();

    public static void main(String[] args) {

        try {

            // =========================================================
            // 1. READ COMMAND-LINE ARGUMENTS
            // =========================================================

            String pageArgument =
                    args.length > 0 ? args[0] : "1";

            String brand =
                    args.length > 1 ? args[1] : null;

            String limitArgument =
                    args.length > 2 ? args[2] : "10";

            int page;
            int limit;

            try {
                page = Integer.parseInt(pageArgument);
            } catch (NumberFormatException e) {
                throw new RuntimeException(
                        "Page must be a valid integer."
                );
            }

            try {
                limit = Integer.parseInt(limitArgument);
            } catch (NumberFormatException e) {
                throw new RuntimeException(
                        "Limit must be a valid integer."
                );
            }

            if (brand == null
                    || brand.isBlank()
                    || page < 1
                    || limit < 1) {

                throw new RuntimeException(
                        "Usage: CarSpecsImporter <page> <brand> [limit]"
                );
            }

            // =========================================================
            // 2. READ ENVIRONMENT VARIABLES
            // =========================================================

            String apiBaseUrl =
                    System.getenv("CAR_API_BASE_URL");

            String apiKey =
                    System.getenv("X-API-Key");

            String dbConnectString =
                    System.getenv("DB_CONNECT_STRING");

            String dbUser =
                    System.getenv("DB_USER");

            String dbPassword =
                    System.getenv("DB_PASSWORD");

            if (apiBaseUrl == null
                    || apiBaseUrl.isBlank()) {

                throw new RuntimeException(
                        "CAR_API_BASE_URL must be set."
                );
            }

            if (dbConnectString == null
                    || dbConnectString.isBlank()
                    || dbUser == null
                    || dbUser.isBlank()
                    || dbPassword == null
                    || dbPassword.isBlank()) {

                throw new RuntimeException(
                        "DB_CONNECT_STRING, DB_USER, and DB_PASSWORD must be set."
                );
            }

            // =========================================================
            // 3. GET MODELS FROM get_brand_models
            // =========================================================

            JsonObject modelsResponse =
                    getApiData(
                            apiBaseUrl,
                            apiKey,
                            "get_brand_models",
                            Map.of(
                                    "page",
                                    String.valueOf(page),

                                    "brand",
                                    brand,

                                    "limit",
                                    String.valueOf(limit)
                            )
                    );

            JsonArray models =
                    getRequiredArray(
                            modelsResponse,
                            "models"
                    );

            String responseBrand =
                    getString(
                            modelsResponse,
                            "brand"
                    );

            if (responseBrand == null
                    || responseBrand.isBlank()) {

                responseBrand = brand;
            }

            System.out.println(
                    "Found "
                    + models.size()
                    + " model(s) for "
                    + responseBrand
                    + " on page "
                    + page
            );

            // =========================================================
            // 4. LOAD ORACLE JDBC DRIVER
            // =========================================================

            Class.forName(
                    "oracle.jdbc.driver.OracleDriver"
            );

            // =========================================================
            // 5. CONNECT TO ORACLE
            // =========================================================

            try (Connection connection =
                         DriverManager.getConnection(
                                 dbConnectString,
                                 dbUser,
                                 dbPassword)) {

                connection.setAutoCommit(false);

                // -----------------------------------------------------
                // Find CAR_ID from CAR_DETAILS
                // -----------------------------------------------------

                String findCarIdSql =
                        "SELECT car_id "
                        + "FROM car_details "
                        + "WHERE LOWER(brand) = LOWER(?) "
                        + "AND LOWER(model_name) = LOWER(?)";

                // -----------------------------------------------------
                // Insert specification data
                // -----------------------------------------------------

                String insertSql =
                        "INSERT INTO car_specs ("
                        + "car_id, "
                        + "brand, "
                        + "model, "
                        + "length, "
                        + "width, "
                        + "height, "
                        + "wheelbase, "
                        + "engine_type, "
                        + "displacement, "
                        + "motor_type, "
                        + "max_power, "
                        + "max_torque, "
                        + "no_of_cylinders, "
                        + "valves_per_cylinder, "
                        + "battery_type, "
                        + "regenerative_braking, "
                        + "wireless_charging, "
                        + "transmission_type, "
                        + "gearbox, "
                        + "hybrid_type, "
                        + "drive_type, "
                        + "fuel_type, "
                        + "petrol_mileage_arai, "
                        + "petrol_fuel_tank_capacity, "
                        + "emission_norm_compliance, "
                        + "front_suspension, "
                        + "rear_suspension, "
                        + "steering_type, "
                        + "steering_column, "
                        + "steering_gear_type, "
                        + "turning_radius, "
                        + "front_brake_type, "
                        + "rear_brake_type, "
                        + "seating_capacity, "
                        + "gross_weight, "
                        + "source_url"
                        + ") VALUES ("
                        + "?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "
                        + "?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "
                        + "?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "
                        + "?, ?, ?, ?, ?, ?"
                        + ")";

                try (
                    PreparedStatement findCarIdStatement =
                            connection.prepareStatement(
                                    findCarIdSql
                            );

                    PreparedStatement insertStatement =
                            connection.prepareStatement(
                                    insertSql
                            )
                ) {

                    // =================================================
                    // 6. PROCESS EACH MODEL
                    // =================================================

                    for (JsonElement modelElement : models) {

                        JsonObject model =
                                modelElement.getAsJsonObject();

                        String modelName =
                                getString(
                                        model,
                                        "model_name"
                                );

                        String modelSlug =
                                getString(
                                        model,
                                        "model_slug"
                                );

                        if (modelSlug == null
                                || modelSlug.isBlank()) {

                            System.out.println(
                                    "Skipping model because "
                                    + "model_slug is missing."
                            );

                            continue;
                        }

                        System.out.println(
                                "\nProcessing: "
                                + modelName
                                + " ("
                                + modelSlug
                                + ")"
                        );

                        // =============================================
                        // 7. FIND CAR_ID FROM CAR_DETAILS
                        // =============================================

                        findCarIdStatement.setString(
                                1,
                                responseBrand
                        );

                        findCarIdStatement.setString(
                                2,
                                modelName
                        );

                        int carId = -1;

                        try (
                            ResultSet resultSet =
                                    findCarIdStatement.executeQuery()
                        ) {

                            if (resultSet.next()) {

                                carId =
                                        resultSet.getInt(
                                                "car_id"
                                        );
                            }
                        }

                        if (carId == -1) {

                            System.out.println(
                                    "Skipping "
                                    + modelName
                                    + " because no matching "
                                    + "CAR_ID was found in CAR_DETAILS."
                            );

                            continue;
                        }

                        System.out.println(
                                "CAR_ID: " + carId
                        );

                        // =============================================
                        // 8. CALL get_specifications
                        // =============================================

                        JsonObject specsResponse =
                                getApiData(
                                        apiBaseUrl,
                                        apiKey,
                                        "get_specifications",
                                        Map.of(
                                                "brand",
                                                responseBrand,

                                                "model",
                                                modelSlug
                                        )
                                );

                        // =============================================
                        // 9. EXTRACT TOP-LEVEL DATA
                        // =============================================

                        String specsBrand =
                                getString(
                                        specsResponse,
                                        "brand"
                                );

                        String specsModel =
                                getString(
                                        specsResponse,
                                        "model"
                                );

                        String sourceUrl =
                                getString(
                                        specsResponse,
                                        "url"
                                );

                        // =============================================
                        // 10. EXTRACT DIMENSIONS
                        // =============================================

                        JsonObject dimensions =
                                getObject(
                                        specsResponse,
                                        "dimensions"
                                );

                        String length =
                                getString(
                                        dimensions,
                                        "length"
                                );

                        String width =
                                getString(
                                        dimensions,
                                        "width"
                                );

                        String height =
                                getString(
                                        dimensions,
                                        "height"
                                );

                        String wheelbase =
                                getString(
                                        dimensions,
                                        "wheelbase"
                                );

                        // =============================================
                        // 11. EXTRACT SECTION ITEMS
                        // =============================================

                        Map<String, String> specificationValues =
                                new HashMap<>();

                        JsonArray sections =
                                getRequiredArray(
                                        specsResponse,
                                        "sections"
                                );

                        for (JsonElement sectionElement :
                                sections) {

                            JsonObject section =
                                    sectionElement.getAsJsonObject();

                            JsonArray items =
                                    getRequiredArray(
                                            section,
                                            "items"
                                    );

                            for (JsonElement itemElement :
                                    items) {

                                JsonObject item =
                                        itemElement.getAsJsonObject();

                                String name =
                                        getString(
                                                item,
                                                "name"
                                        );

                                String value =
                                        getString(
                                                item,
                                                "value"
                                        );

                                if (name != null
                                        && !name.isBlank()) {

                                    specificationValues.put(
                                            normalize(name),
                                            value
                                    );
                                }
                            }
                        }

                        // =============================================
                        // 12. GET VALUES USING API FIELD NAMES
                        // =============================================

                        String engineType =
                                specificationValues.get(
                                        "ENGINE_TYPE"
                                );

                        String displacement =
                                specificationValues.get(
                                        "DISPLACEMENT"
                                );

                        String motorType =
                                specificationValues.get(
                                        "MOTOR_TYPE"
                                );

                        String maxPower =
                                specificationValues.get(
                                        "MAX_POWER"
                                );

                        String maxTorque =
                                specificationValues.get(
                                        "MAX_TORQUE"
                                );

                        String noOfCylinders =
                                specificationValues.get(
                                        "NO_OF_CYLINDERS"
                                );

                        String valvesPerCylinder =
                                specificationValues.get(
                                        "VALVES_PER_CYLINDER"
                                );

                        String batteryType =
                                specificationValues.get(
                                        "BATTERY_TYPE"
                                );

                        String regenerativeBraking =
                                specificationValues.get(
                                        "REGENERATIVE_BRAKING"
                                );

                        String wirelessCharging =
                                specificationValues.get(
                                        "WIRELESS_CHARGING"
                                );

                        String transmissionType =
                                specificationValues.get(
                                        "TRANSMISSION_TYPE"
                                );

                        String gearbox =
                                specificationValues.get(
                                        "GEARBOX"
                                );

                        String hybridType =
                                specificationValues.get(
                                        "HYBRID_TYPE"
                                );

                        String driveType =
                                specificationValues.get(
                                        "DRIVE_TYPE"
                                );

                        String fuelType =
                                specificationValues.get(
                                        "FUEL_TYPE"
                                );

                        String petrolMileageArai =
                                specificationValues.get(
                                        "PETROL_MILEAGE_ARAI"
                                );

                        String petrolFuelTankCapacity =
                                specificationValues.get(
                                        "PETROL_FUEL_TANK_CAPACITY"
                                );

                        String emissionNormCompliance =
                                specificationValues.get(
                                        "EMISSION_NORM_COMPLIANCE"
                                );

                        String frontSuspension =
                                specificationValues.get(
                                        "FRONT_SUSPENSION"
                                );

                        String rearSuspension =
                                specificationValues.get(
                                        "REAR_SUSPENSION"
                                );

                        String steeringType =
                                specificationValues.get(
                                        "STEERING_TYPE"
                                );

                        String steeringColumn =
                                specificationValues.get(
                                        "STEERING_COLUMN"
                                );

                        String steeringGearType =
                                specificationValues.get(
                                        "STEERING_GEAR_TYPE"
                                );

                        String turningRadius =
                                specificationValues.get(
                                        "TURNING_RADIUS"
                                );

                        String frontBrakeType =
                                specificationValues.get(
                                        "FRONT_BRAKE_TYPE"
                                );

                        String rearBrakeType =
                                specificationValues.get(
                                        "REAR_BRAKE_TYPE"
                                );

                        String seatingCapacity =
                                specificationValues.get(
                                        "SEATING_CAPACITY"
                                );

                        String grossWeight =
                                specificationValues.get(
                                        "GROSS_WEIGHT"
                                );

                        // =============================================
                        // 13. BIND VALUES
                        // =============================================

                        int parameter = 1;

                        insertStatement.setInt(
                                parameter++,
                                carId
                        );

                        insertStatement.setString(
                                parameter++,
                                specsBrand
                        );

                        insertStatement.setString(
                                parameter++,
                                specsModel
                        );

                        insertStatement.setString(
                                parameter++,
                                length
                        );

                        insertStatement.setString(
                                parameter++,
                                width
                        );

                        insertStatement.setString(
                                parameter++,
                                height
                        );

                        insertStatement.setString(
                                parameter++,
                                wheelbase
                        );

                        insertStatement.setString(
                                parameter++,
                                engineType
                        );

                        insertStatement.setString(
                                parameter++,
                                displacement
                        );

                        insertStatement.setString(
                                parameter++,
                                motorType
                        );

                        insertStatement.setString(
                                parameter++,
                                maxPower
                        );

                        insertStatement.setString(
                                parameter++,
                                maxTorque
                        );

                        insertStatement.setString(
                                parameter++,
                                noOfCylinders
                        );

                        insertStatement.setString(
                                parameter++,
                                valvesPerCylinder
                        );

                        insertStatement.setString(
                                parameter++,
                                batteryType
                        );

                        insertStatement.setString(
                                parameter++,
                                regenerativeBraking
                        );

                        insertStatement.setString(
                                parameter++,
                                wirelessCharging
                        );

                        insertStatement.setString(
                                parameter++,
                                transmissionType
                        );

                        insertStatement.setString(
                                parameter++,
                                gearbox
                        );

                        insertStatement.setString(
                                parameter++,
                                hybridType
                        );

                        insertStatement.setString(
                                parameter++,
                                driveType
                        );

                        insertStatement.setString(
                                parameter++,
                                fuelType
                        );

                        insertStatement.setString(
                                parameter++,
                                petrolMileageArai
                        );

                        insertStatement.setString(
                                parameter++,
                                petrolFuelTankCapacity
                        );

                        insertStatement.setString(
                                parameter++,
                                emissionNormCompliance
                        );

                        insertStatement.setString(
                                parameter++,
                                frontSuspension
                        );

                        insertStatement.setString(
                                parameter++,
                                rearSuspension
                        );

                        insertStatement.setString(
                                parameter++,
                                steeringType
                        );

                        insertStatement.setString(
                                parameter++,
                                steeringColumn
                        );

                        insertStatement.setString(
                                parameter++,
                                steeringGearType
                        );

                        insertStatement.setString(
                                parameter++,
                                turningRadius
                        );

                        insertStatement.setString(
                                parameter++,
                                frontBrakeType
                        );

                        insertStatement.setString(
                                parameter++,
                                rearBrakeType
                        );

                        insertStatement.setString(
                                parameter++,
                                seatingCapacity
                        );

                        insertStatement.setString(
                                parameter++,
                                grossWeight
                        );

                        insertStatement.setString(
                                parameter++,
                                sourceUrl
                        );

                        // =============================================
                        // 14. INSERT THIS MODEL
                        // =============================================

                        insertStatement.executeUpdate();

                        System.out.println(
                                "Inserted specifications for "
                                + modelName
                        );
                    }

                    // =================================================
                    // 15. COMMIT
                    // =================================================

                    connection.commit();

                    System.out.println(
                            "\nSuccessfully imported "
                            + models.size()
                            + " model(s)."
                    );
                }
            }

        } catch (Exception e) {

            System.err.println(
                    "Import failed: "
                    + e.getMessage()
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

        URI uri =
                buildEndpoint(
                        apiBaseUrl,
                        path,
                        parameters
                );

        System.out.println(
                "API Request: " + uri
        );

        HttpRequest.Builder requestBuilder =
                HttpRequest.newBuilder()
                        .uri(uri)
                        .GET();

        if (apiKey != null
                && !apiKey.isBlank()) {

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
                getString(
                        payload,
                        "status"
                );

        JsonElement data =
                getElement(
                        payload,
                        "data"
                );

        if (!"success".equals(status)
                || data == null
                || data.isJsonNull()) {

            throw new RuntimeException(
                    path
                    + " returned an unsuccessful payload:\n"
                    + response.body()
            );
        }

        return data.getAsJsonObject();
    }

    // ================================================================
    // BUILD URL
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

            url.append(
                    first ? "?" : "&"
            );

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

        return URI.create(
                url.toString()
        );
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
                getElement(
                        object,
                        name
                );

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
                getElement(
                        object,
                        name
                );

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
                getElement(
                        object,
                        name
                );

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
    // NORMALIZE API FIELD NAMES
    // ================================================================

    private static String normalize(
            String value) {

        return value
                .trim()
                .toUpperCase()
                .replaceAll(
                        "[^A-Z0-9]+",
                        "_"
                )
                .replaceAll(
                        "^_|_$",
                        ""
                );
    }
}