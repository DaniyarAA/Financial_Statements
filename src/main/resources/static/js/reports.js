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
                errorContainer.textContent = "Произошла ошибка при отправке формы.";
                errorContainer.style.display = "block";
            }
        }

        csvButton.addEventListener('click', function (event) {
            event.preventDefault();
            actionUrl = '/api/reports/' + formId.replace('ReportForm', '').toLowerCase() + '/csv';
            submitForm(event);
        });

        pdfButton.addEventListener('click', function (event) {
            event.preventDefault();
            actionUrl = '/api/reports/' + formId.replace('ReportForm', '').toLowerCase() + '/pdf';
            submitForm(event);
        });
    }
    setupFormHandlers("monthlyReportForm", "downloadMonthlyCsvButton", "downloadMonthlyPdfButton", "companyCheckboxesMonthly", "monthlyErrorContainer");
    setupFormHandlers("quarterlyReportForm", "downloadQuarterlyCsvButton", "downloadQuarterlyPdfButton", "companyCheckboxesQuarterly", "quarterlyErrorContainer");
    setupFormHandlers("yearlyReportForm", "downloadYearlyCsvButton", "downloadYearlyPdfButton", "companyCheckboxesYearly", "yearlyErrorContainer");
});
