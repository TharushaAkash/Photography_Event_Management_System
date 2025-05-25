<%@ page import="java.io.*, java.util.*" %>
<%
    String filePath   = application.getRealPath("/") + "Booking.txt";
    Queue<String[]> bookings = new LinkedList<>();

    try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
        String line;
        while ((line = reader.readLine()) != null) {
            if (line.trim().isEmpty()) continue;
            String[] parts = line.split(",");
            String[] full  = new String[6];
            for (int i = 0; i < 6; i++) {
                full[i] = i < parts.length ? parts[i] : "";
            }
            bookings.add(full);
        }
    } catch (Exception e) {
        // you might log this
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Bookings</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-black text-white font-sans">
<div class="min-h-screen p-6">
    <h1 class="text-3xl font-bold text-center mb-6">All Bookings</h1>
    <div class="overflow-x-auto">
        <table class="table-auto w-full border border-white text-left">
            <thead class="bg-gray-800 text-white">
            <tr>
                <th class="px-4 py-2">ID</th>
                <th class="px-4 py-2">Event</th>
                <th class="px-4 py-2">Type</th>
                <th class="px-4 py-2">Date</th>
                <th class="px-4 py-2">Location</th>
                <th class="px-4 py-2">Photographer</th>
                <th class="px-4 py-2">Update</th>
                <th class="px-4 py-2">Delete</th>
            </tr>
            </thead>
            <tbody>
            <% for (String[] b : bookings) { %>
            <tr class="hover:bg-gray-700">
                <td class="border px-4 py-2"><%= b[0] %></td>
                <td class="border px-4 py-2"><%= b[1] %></td>
                <td class="border px-4 py-2"><%= b[2] %></td>
                <td class="border px-4 py-2"><%= b[3] %></td>
                <td class="border px-4 py-2"><%= b[4] %></td>
                <td class="border px-4 py-2"><%= b[5] %></td>
                <td class="border px-4 py-2">
                    <a href="update.jsp?id=<%= b[0] %>" class="bg-blue-600 text-white px-3 py-1 rounded hover:bg-blue-700">
                        Update
                    </a>
                </td>
                <td class="border px-4 py-2">
                    <button onclick="confirmDelete('<%= b[0] %>')"
                            class="bg-red-600 text-white px-3 py-1 rounded hover:bg-red-700">
                        Delete
                    </button>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div id="deleteModal"
     class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center hidden">
    <div class="bg-gray-800 p-6 rounded-2xl shadow-lg w-80">
        <p class="text-white text-lg mb-6">Are you sure about deleting this order?</p>
        <div class="flex justify-end space-x-4">
            <button id="cancelBtn"
                    class="bg-gray-600 hover:bg-gray-700 px-4 py-2 rounded-lg text-white">
                No
            </button>
            <a id="confirmDeleteBtn" href="#"
               class="bg-red-600 hover:bg-red-700 px-4 py-2 rounded-lg text-white">
                Yes
            </a>
        </div>
    </div>
</div>

<script>
    function confirmDelete(id) {
        const modal = document.getElementById('deleteModal');
        const yesBtn = document.getElementById('confirmDeleteBtn');
        yesBtn.href = 'delete.jsp?id=' + id;
        modal.classList.remove('hidden');
    }
    document.getElementById('cancelBtn').addEventListener('click', () => {
        document.getElementById('deleteModal').classList.add('hidden');
    });
</script>
</body>
</html>
