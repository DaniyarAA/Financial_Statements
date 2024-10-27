function toggleCreateForm() {
    const createCompanyForm = document.getElementById('createCompanyForm');
    const companyInfo = document.getElementById('companyInfo');

    // If the createCompanyForm is currently displayed, hide it and show companyInfo
    if (createCompanyForm.style.display === "block") {
        createCompanyForm.style.display = "none"; // Hide the form
        companyInfo.style.display = "block"; // Show companyInfo
    } else {
        // Otherwise, show createCompanyForm and hide companyInfo
        companyInfo.style.display = "none"; // Hide companyInfo
        createCompanyForm.style.display = "block"; // Show the form
    }
}