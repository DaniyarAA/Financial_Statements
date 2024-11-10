document.addEventListener("DOMContentLoaded", function () {
    const monthSelect = document.getElementById("month");
    const yearSelect = document.getElementById("year");
    const quarterSelect = document.getElementById("quarter");
    const weekSelect = document.getElementById("week");
    const reportTypeRadios = document.getElementsByName("reportType");
    const startDateTimeDisplay = document.getElementById("startDateTimeDisplay");
    const endDateTimeDisplay = document.getElementById("endDateTimeDisplay");
    const startDateTimeInput = document.getElementById("startDateTime");
    const endDateTimeInput = document.getElementById("endDateTime");
    const weekSelectionDiv = document.getElementById("weekSelection");
    const decadeSelectionDiv = document.getElementById("decadeSelection");

    function cleaning() {
        monthSelect.value = "";
        yearSelect.value = "";
        quarterSelect.value = "";
        weekSelect.value = "";
        startDateTimeDisplay.value = "";
        endDateTimeDisplay.value = "";
        startDateTimeInput.value = "";
        endDateTimeInput.value = "";
    }

    function updateDates() {
        const reportType = document.querySelector('input[name="reportType"]:checked').value;
        const month = parseInt(monthSelect.value);
        const year = parseInt(yearSelect.value);
        const quarter = parseInt(quarterSelect.value);

        if (reportType === "weekly" && month && year && weekSelect.value) {
            const week = parseInt(weekSelect.value);
            const startDay = (week - 1) * 7 + 1;
            const startDate = new Date(Date.UTC(year, month - 1, startDay));
            const endDate = new Date(Date.UTC(year, month - 1, startDay + 6));

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
        } else if (reportType === "monthly" && month && year) {
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
        }
        else if (reportType === "decadal" && month && year) {
            let startDay, endDay;

            switch (quarter) {
                case 1:
                    startDay = 1;
                    endDay = 10;
                    break;
                case 2:
                    startDay = 11;
                    endDay = 20;
                    break;
                case 3:
                    startDay = 21;
                    endDay = new Date(year, month, 0).getDate();
                    break;
                default:
                    return;
            }

            const startDate = new Date(Date.UTC(year, month - 1, startDay));
            const endDate = new Date(Date.UTC(year, month - 1, endDay));

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
        }

        else {
            startDateTimeDisplay.value = "";
            endDateTimeDisplay.value = "";
            startDateTimeInput.value = "";
            endDateTimeInput.value = "";
        }
    }

    reportTypeRadios.forEach(radio => {
        radio.addEventListener("change", function () {
            cleaning();
            if (radio.value === "weekly") {
                weekSelectionDiv.style.display = "block";
                decadeSelectionDiv.style.display = "none";
            } else if (radio.value === "decadal") {
                weekSelectionDiv.style.display = "none";
                decadeSelectionDiv.style.display = "block";
            } else {
                weekSelectionDiv.style.display = "none";
                decadeSelectionDiv.style.display = "none";
            }
            updateDates();
        });
    });

    monthSelect.addEventListener("change", updateDates);
    yearSelect.addEventListener("change", updateDates);
    weekSelect.addEventListener("change", updateDates);
    quarterSelect.addEventListener("change", updateDates);
});