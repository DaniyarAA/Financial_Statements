document.addEventListener("DOMContentLoaded", function () {
    const monthSelect = document.getElementById("month");
    const yearSelect = document.getElementById("year");
    const quarterSelect = document.getElementById("quarter");
    const decadeSelect = document.getElementById("decade");
    const weekSelect = document.getElementById("week");
    const reportTypeRadios = document.getElementsByName("reportType");
    const startDateDisplay = document.getElementById("startDateDisplay");
    const endDateDisplay = document.getElementById("endDateDisplay");
    const startDateInput = document.getElementById("startDate");
    const endDateInput = document.getElementById("endDate");
    const weekSelectionDiv = document.getElementById("weekSelection");
    const decadeSelectionDiv = document.getElementById("decadeSelection");
    const quarterSelectionDiv = document.getElementById("quarterSelection");
    const monthSelectionDiv = document.getElementById("monthSelection");

    function cleaning() {
        monthSelect.value = "";
        yearSelect.value = "";
        quarterSelect.value = "";
        decadeSelect.value = "";
        weekSelect.value = "";
        startDateDisplay.value = "";
        endDateDisplay.value = "";
        startDateInput.value = "";
        endDateInput.value = "";
    }

    function updateDates() {
        const reportType = document.querySelector('input[name="reportType"]:checked').value;
        const month = parseInt(monthSelect.value);
        const year = parseInt(yearSelect.value);
        const quarter = parseInt(quarterSelect.value);
        const decade = parseInt(decadeSelect.value);
        const week = parseInt(weekSelect.value);

        if (reportType === "weekly" && month && year && week) {
            const startDay = (week - 1) * 7 + 1;
            const startDate = new Date(Date.UTC(year, month - 1, startDay));
            const endDate = new Date(Date.UTC(year, month - 1, startDay + 6));

            const formattedStartDate = startDate.toLocaleDateString("ru-RU");
            const formattedEndDate = endDate.toLocaleDateString("ru-RU");

            startDateDisplay.value = formattedStartDate;
            endDateDisplay.value = formattedEndDate;

            startDateInput.value = startDate.toISOString().split("T")[0];
            endDateInput.value = endDate.toISOString().split("T")[0];

        } else if (reportType === "monthly" && month && year) {
            const startDate = new Date(Date.UTC(year, month - 1, 1));
            const endDate = new Date(Date.UTC(year, month, 0));

            const formattedStartDate = startDate.toLocaleDateString("ru-RU");
            const formattedEndDate = endDate.toLocaleDateString("ru-RU");

            startDateDisplay.value = formattedStartDate;
            endDateDisplay.value = formattedEndDate;

            startDateInput.value = startDate.toISOString().split("T")[0];
            endDateInput.value = endDate.toISOString().split("T")[0];

        } else if (reportType === "quarterly" && quarter && year) {
            const startDate = new Date(Date.UTC(year, (quarter - 1) * 3, 1));
            const endDate = new Date(Date.UTC(year, quarter * 3, 0));

            const formattedStartDate = startDate.toLocaleDateString("ru-RU");
            const formattedEndDate = endDate.toLocaleDateString("ru-RU");

            startDateDisplay.value = formattedStartDate;
            endDateDisplay.value = formattedEndDate;

            startDateInput.value = startDate.toISOString().split("T")[0];
            endDateInput.value = endDate.toISOString().split("T")[0];

        } else if (reportType === "decadal" && month && year && decade) {
            let startDate, endDate;
            if (decade === 1) {
                startDate = new Date(Date.UTC(year, month - 1, 1));
                endDate = new Date(Date.UTC(year, month - 1, 10));
            } else if (decade === 2) {
                startDate = new Date(Date.UTC(year, month - 1, 11));
                endDate = new Date(Date.UTC(year, month - 1, 20));
            } else if (decade === 3) {
                startDate = new Date(Date.UTC(year, month - 1, 21));
                endDate = new Date(Date.UTC(year, month, 0));
            }

            const formattedStartDate = startDate.toLocaleDateString("ru-RU");
            const formattedEndDate = endDate.toLocaleDateString("ru-RU");

            startDateDisplay.value = formattedStartDate;
            endDateDisplay.value = formattedEndDate;

            startDateInput.value = startDate.toISOString().split("T")[0];
            endDateInput.value = endDate.toISOString().split("T")[0];

        } else if (reportType === "annual" && year) {
            const startDate = new Date(Date.UTC(year, 0, 1));
            const endDate = new Date(Date.UTC(year, 11, 31));

            const formattedStartDate = startDate.toLocaleDateString("ru-RU");
            const formattedEndDate = endDate.toLocaleDateString("ru-RU");

            startDateDisplay.value = formattedStartDate;
            endDateDisplay.value = formattedEndDate;

            startDateInput.value = startDate.toISOString().split("T")[0];
            endDateInput.value = endDate.toISOString().split("T")[0];
        }
    }

    function defaultType() {
        const reportType = document.querySelector('input[name="reportType"]:checked');

        if (reportType) {
            reportType.dispatchEvent(new Event('change'));
        } else {
            reportTypeRadios[0].checked = true;
            reportTypeRadios[0].dispatchEvent(new Event('change'));
        }
    }

    reportTypeRadios.forEach(radio => {
        radio.addEventListener("change", function () {
            const reportType = this.value;

            if (reportType === "weekly") {
                weekSelectionDiv.style.display = "block";
                decadeSelectionDiv.style.display = "none";
                quarterSelectionDiv.style.display = "none";
                monthSelectionDiv.style.display = "block";
            } else if (reportType === "decadal") {
                weekSelectionDiv.style.display = "none";
                decadeSelectionDiv.style.display = "block";
                quarterSelectionDiv.style.display = "none";
                monthSelectionDiv.style.display = "block";
            } else if (reportType === "quarterly") {
                weekSelectionDiv.style.display = "none";
                decadeSelectionDiv.style.display = "none";
                monthSelectionDiv.style.display = "none";
                quarterSelectionDiv.style.display = "block";
            } else if (reportType === "monthly") {
                monthSelectionDiv.style.display = "block";
                weekSelectionDiv.style.display = "none";
                decadeSelectionDiv.style.display = "none";
                quarterSelectionDiv.style.display = "none";
            } else if (reportType === "annual") {
                monthSelectionDiv.style.display = "none";
                weekSelectionDiv.style.display = "none";
                decadeSelectionDiv.style.display = "none";
                quarterSelectionDiv.style.display = "none";
            } else {
                weekSelectionDiv.style.display = "none";
                decadeSelectionDiv.style.display = "none";
                quarterSelectionDiv.style.display = "none";
                monthSelectionDiv.style.display = "none";
            }
            cleaning();
            updateDates();
        });
    });

    defaultType();

    monthSelect.addEventListener("change", updateDates);
    yearSelect.addEventListener("change", updateDates);
    quarterSelect.addEventListener("change", updateDates);
    decadeSelect.addEventListener("change", updateDates);
    weekSelect.addEventListener("change", updateDates);
})