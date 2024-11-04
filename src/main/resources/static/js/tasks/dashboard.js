document.addEventListener("DOMContentLoaded", function() {
    const taskDetailsDiv = document.createElement("div");
    taskDetailsDiv.id = "task-details";
    taskDetailsDiv.style.display = "none";
    taskDetailsDiv.style.width = "33%";
    taskDetailsDiv.style.padding = "1rem";
    taskDetailsDiv.style.border = "1px solid #ddd";
    taskDetailsDiv.style.backgroundColor = "#f9f9f9";

    document.body.appendChild(taskDetailsDiv);
});

function showTaskDetails(taskId) {
    const taskDetailsDiv = document.getElementById("task-details");

    taskDetailsDiv.style.display = "block";

    taskDetailsDiv.innerHTML = `<h3>Task Details</h3><p>Loading details for task ID: ${taskId}</p>`;
}
