package com.example.event_booking_project_90.util;

import com.example.event_booking_project_90.model.Payment;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentRepository {
    private static final String FILE_PATH = "C:\\Users\\imzya\\IdeaProjects\\PaymentFinal\\src\\main\\webapp\\payments.txt";

    public void savePayment(Payment payment) throws IOException {
        File file = new File(FILE_PATH);
        file.getParentFile().mkdirs();
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file, true))) {
            writer.write(payment.toFileString());
            writer.newLine();
        }
    }

    public List<Payment> getAllPayments() throws IOException {
        List<Payment> payments = new ArrayList<>();
        File file = new File(FILE_PATH);
        if (file.exists()) {
            try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    String[] parts = line.split(",");
                    if (parts.length == 3) {
                        payments.add(new Payment(parts[0], parts[1], parts[2]));
                    }
                }
            }
        }
        return payments;
    }
}