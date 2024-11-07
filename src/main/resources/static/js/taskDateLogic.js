document.addEventListener("DOMContentLoaded", function () {
    const monthSelect = document.getElementById("month");
    const yearSelect = document.getElementById("year");
    const startDateTimeDisplay = document.getElementById("startDateTimeDisplay");
    const endDateTimeDisplay = document.getElementById("endDateTimeDisplay");
    const startDateTimeInput = document.getElementById("startDateTime");
    const endDateTimeInput = document.getElementById("endDateTime");

    function updateDates() {
        const month = parseInt(monthSelect.value);
        const year = parseInt(yearSelect.value);

        if (month && year) {
            const startDate = new Date(Date.UTC(year, month - 1, 1));
            const endDate = new Date(Date.UTC(year, month, 0));

            const formattedStartDate = startDate.toLocaleDateString("ru-RU", {
                day: "2-digit",
                month: "2-digit",
                year: "numeric"
            });
            const formattedEndDate = endDate.toLocaleDateString("ru-RU", {
                day: "2-digit",
                month: "2-digit",
                year: "numeric"
            });

            startDateTimeDisplay.value = formattedStartDate;
            endDateTimeDisplay.value = formattedEndDate;

            startDateTimeInput.value = startDate.toISOString().split("T")[0] + "T00:00:00";
            endDateTimeInput.value = endDate.toISOString().split("T")[0] + "T23:59:59";
        } else {
            startDateTimeDisplay.value = "";
            endDateTimeDisplay.value = "";
            startDateTimeInput.value = "";
            endDateTimeInput.value = "";
        }
    }

    monthSelect.addEventListener("change", updateDates);
    yearSelect.addEventListener("change", updateDates);
});