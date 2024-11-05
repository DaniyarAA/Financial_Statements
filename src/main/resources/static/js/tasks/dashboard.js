function showTaskDetails(taskId) {
    document.getElementById('task-details').style.display = 'block';

    $.ajax({
        url: '/dashboard/task-details',
        method: 'GET',
        data: { taskId: taskId },
        success: function(data) {
            $('#task-content').html(`
                    <p><strong>Task ID:</strong> ${data.id}</p>
                    <p><strong>Document Type:</strong> ${data.documentTypeName}</p>
                    <p><strong>Start Date:</strong> ${data.startDateTime}</p>
                    <p><strong>Company:</strong> ${data.company.name}</p>
                    <!-- Add more details as needed -->
                `);
        },
        error: function() {
            $('#task-content').html('<p class="text-danger">Error loading task details.</p>');
        }
    });
}