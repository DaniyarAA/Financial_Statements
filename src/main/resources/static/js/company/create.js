function toggleCreateForm() {
    const createCompanyForm = document.getElementById('createCompanyForm');
    const companyInfo = document.getElementById('companyInfo');

    if (createCompanyForm.style.display === "block") {
        createCompanyForm.style.display = "none";
        companyInfo.style.display = "block";
    } else {
        companyInfo.style.display = "none";
        createCompanyForm.style.display = "block";
    }
}