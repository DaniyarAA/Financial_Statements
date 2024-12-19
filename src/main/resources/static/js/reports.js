document.addEventListener("DOMContentLoaded", function () {
    function setupModal(modalId, searchInputId, selectAllId, checkboxesId) {
        const searchInput = document.getElementById(searchInputId);
        const companyCheckboxes = document.getElementById(checkboxesId);
        const selectAllCheckbox = document.getElementById(selectAllId);

        searchInput.addEventListener("input", function () {
            const searchTerm = searchInput.value.toLowerCase();

            Array.from(companyCheckboxes.children).forEach(div => {
                const label = div.querySelector("label");
                if (label.textContent.toLowerCase().includes(searchTerm)) {
                    div.style.display = "block";
                } else {
                    div.style.display = "none";
                }
            });
        });

        selectAllCheckbox.addEventListener("change", function () {
            const isChecked = selectAllCheckbox.checked;
            Array.from(companyCheckboxes.children).forEach(div => {
                if (div.style.display !== "none") {
                    const checkbox = div.querySelector("input[type='checkbox']");
                    if (checkbox) {
                        checkbox.checked = isChecked;
                    }
                }
            });
        });

        function setupDatePickers(startDateId, endDateId, defaultRange) {
            const startDateInput = document.getElementById(startDateId);
            const endDateInput = document.getElementById(endDateId);

            function calculateDateRange(rangeType) {
                const today = new Date();
                if (rangeType === "monthly") {
                    return {
                        start: new Date(today.getFullYear(), today.getMonth(), 1),
                        end: new Date(today.getFullYear(), today.getMonth() + 1, 0),
                    };
                } else if (rangeType === "quarterly") {
                    const quarterStartMonth = Math.floor(today.getMonth() / 3) * 3;
                    return {
                        start: new Date(today.getFullYear(), quarterStartMonth, 1),
                        end: new Date(today.getFullYear(), quarterStartMonth + 3, 0),
                    };
                } else if (rangeType === "yearly") {
                    return {
                        start: new Date(today.getFullYear(), 0, 1),
                        end: new Date(today.getFullYear(), 11, 31),
                    };
                }
                return { start: today, end: today };
            }

            const { start, end } = calculateDateRange(defaultRange);
            startDateInput.value = formatDate(start);
            endDateInput.value = formatDate(end);

            function formatDate(date) {
                const year = date.getFullYear();
                const month = String(date.getMonth() + 1).padStart(2, "0");
                const day = String(date.getDate()).padStart(2, "0");
                return `${year}-${month}-${day}`;
            }
        }

        setupDatePickers("startDateMonthly", "endDateMonthly", "monthly");
        setupDatePickers("startDateQuarterly", "endDateQuarterly", "quarterly");
        setupDatePickers("startDateYearly", "endDateYearly", "yearly");
    }
    setupModal("monthlyReportModal", "companySearchMonthly", "selectAllMonthly", "companyCheckboxesMonthly");
    setupModal("quarterlyReportModal", "companySearchQuarterly", "selectAllQuarterly", "companyCheckboxesQuarterly");
    setupModal("yearlyReportModal", "companySearchYearly", "selectAllYearly", "companyCheckboxesYearly");


    function setupFormHandlers(formId, csvButtonId, pdfButtonId, checkboxContainerId, errorContainerId){
        const form = document.getElementById(formId);
        const csvButton = document.getElementById(csvButtonId);
        const pdfButton = document.getElementById(pdfButtonId);
        const checkboxes = document.querySelectorAll("#" + checkboxContainerId + ' .form-check-input');
        const errorContainer = document.getElementById(errorContainerId);
        let actionUrl = form.getAttribute('action');

        function validateForm() {
            errorContainer.textContent = "";
            errorContainer.style.display = "none";

            const isSelected = Array.from(checkboxes).some((checkbox) => checkbox.checked);
            if (!isSelected) {
                errorContainer.textContent = "Выберите хотя бы одну компанию.";
                errorContainer.style.display = "block";
                return false;
            }
            return true;
        }

        async function submitForm(event) {
            event.preventDefault();

            if (!validateForm()) return;

            const formData = new FormData(form);

            try {
                const response = await fetch(actionUrl, {
                    method: 'POST',
                    body: formData,
                });

                if (!response.ok) {
                    const data = await response.json();
                    errorContainer.textContent = data.message || "Ошибка на сервере.";
                    errorContainer.style.display = "block";
                    return;
                }

                const contentDisposition = response.headers.get("Content-Disposition");
                let filename = "file";
                if (contentDisposition && contentDisposition.includes("filename=")) {
                    const encodedFilename = contentDisposition
                        .split("filename=")[1]
                        .split(";")[0]
                        .replace(/"/g, "");

                    filename = decodeURIComponent(encodedFilename);
                }

                const blob = await response.blob();
                const url = window.URL.createObjectURL(blob);
                const link = document.createElement('a');
                link.href = url;
                link.download = filename;
                link.click();
            } catch (error) {
                errorContainer.textContent = "Произошла ошибка при отправке формы." + error.message;
                errorContainer.style.display = "block";
            }
        }

        csvButton.addEventListener('click', function (event) {
            event.preventDefault();
            actionUrl = '/api/reports/csv';
            submitForm(event);
        });

        pdfButton.addEventListener('click', function (event) {
            event.preventDefault();
            actionUrl = '/api/reports/pdf';
            submitForm(event);
        });
    }
    setupFormHandlers("monthlyReportForm", "downloadMonthlyCsvButton", "downloadMonthlyPdfButton", "companyCheckboxesMonthly", "monthlyErrorContainer");
    setupFormHandlers("quarterlyReportForm", "downloadQuarterlyCsvButton", "downloadQuarterlyPdfButton", "companyCheckboxesQuarterly", "quarterlyErrorContainer");
    setupFormHandlers("yearlyReportForm", "downloadYearlyCsvButton", "downloadYearlyPdfButton", "companyCheckboxesYearly", "yearlyErrorContainer");
});
