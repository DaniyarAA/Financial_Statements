function checkTaskFilters(row, statusFilter, documentTypeFilter, dateFilter) {
    const status = row.getAttribute("data-status").toLowerCase();
    const documentType = row.getAttribute("data-document-type").toLowerCase();
    const date = row.getAttribute("data-date");

    const matchesStatus = statusFilter === "" || status === statusFilter;
    const matchesDocumentType = documentTypeFilter === "" || documentType === documentTypeFilter;
    const matchesDate = dateFilter === "" || date === dateFilter;

    return matchesStatus && matchesDocumentType && matchesDate;
}

function taskFiltering() {
    const statusFilter = document.getElementById("statusFilter").value.toLowerCase();
    const documentTypeFilter = document.getElementById("documentTypeFilter").value.toLowerCase();
    const dateFilter = document.getElementById("dateFilter").value;

    const rows = document.querySelectorAll(".task-row");

    rows.forEach(row => {
        if (checkTaskFilters(row, statusFilter, documentTypeFilter, dateFilter)) {
            row.style.display = "";
        } else {
            row.style.display = "none";
        }
    });
}
