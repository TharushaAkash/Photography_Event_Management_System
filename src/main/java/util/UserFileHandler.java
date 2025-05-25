package util;

import java.io.*;
import java.util.*;

public class UserFileHandler {
    private static final String FILE_PATH = "C:/Users/Tharusha/Documents/Y1S2/Janithu_OOP/Event_Booking_System/src/main/webapp/resources/users.txt";

    public static boolean addUser(String username, String email, String password) {
        if (getUser(username) != null) return false; // user exists
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(FILE_PATH, true))) {
            bw.write(username + "," + email + "," + password);
            bw.newLine();
            return true;
        } catch (IOException e) {
            return false;
        }
    }

    public static Map<String, String> getUser(String username) {
        try (BufferedReader br = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] arr = line.split(",", 3);
                if (arr.length == 3 && arr[0].equals(username)) {
                    Map<String, String> user = new HashMap<>();
                    user.put("username", arr[0]);
                    user.put("email", arr[1]);
                    user.put("password", arr[2]);
                    return user;
                }
            }
        } catch (IOException e) {
            // ignore
        }
        return null;
    }

    public static boolean validateUser(String username, String password) {
        Map<String, String> user = getUser(username);
        return user != null && user.get("password").equals(password);
    }

    public static List<Map<String, String>> getAllUsers() {
        List<Map<String, String>> users = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] arr = line.split(",", 3);
                if (arr.length == 3) {
                    Map<String, String> user = new HashMap<>();
                    user.put("username", arr[0]);
                    user.put("email", arr[1]);
                    user.put("password", arr[2]);
                    users.add(user);
                }
            }
        } catch (IOException e) {
            // ignore
        }
        return users;
    }

    public static boolean deleteUser(String username) {
        File inputFile = new File(FILE_PATH);
        File tempFile = new File(FILE_PATH + ".tmp");
        boolean deleted = false;
        try (BufferedReader reader = new BufferedReader(new FileReader(inputFile));
             BufferedWriter writer = new BufferedWriter(new FileWriter(tempFile))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] arr = line.split(",", 3);
                if (arr.length == 3 && arr[0].equals(username)) {
                    deleted = true;
                    continue;
                }
                writer.write(line);
                writer.newLine();
            }
        } catch (IOException e) {
            return false;
        }
        if (deleted) {
            inputFile.delete();
            tempFile.renameTo(inputFile);
        } else {
            tempFile.delete();
        }
        return deleted;
    }

    // Overwrite the user storage file with the updated list
    public static void setAllUsers(List<Map<String, String>> users) {
        // Use the same FILE_PATH as everywhere else
        try (java.io.PrintWriter writer = new java.io.PrintWriter(new java.io.FileWriter(FILE_PATH, false))) {
            for (Map<String, String> user : users) {
                writer.println(
                    user.get("username") + "," +
                    user.get("email") + "," +
                    user.get("password")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Optionally: add update/delete methods as needed
}
