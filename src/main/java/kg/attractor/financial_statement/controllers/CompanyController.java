package kg.attractor.financial_statement.controllers;

import jakarta.validation.Valid;
import kg.attractor.financial_statement.entity.Company;
import kg.attractor.financial_statement.service.CompanyService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.security.Principal;
import java.util.List;

@Controller
@RequestMapping("/company")
@RequiredArgsConstructor
public class CompanyController {
    private final CompanyService companyService;

    @GetMapping("/create")
    public String create(Model model) {
        model.addAttribute("company", new Company());
        return "company/create";
    }

    @PostMapping("/create")
    public String create(@Valid Company company , BindingResult bindingResult , Principal principal ,
                         Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("errors", bindingResult);
            return "company/create";
        }
        companyService.createCompany(company);
        return "redirect:/company/all";
    }

    @GetMapping("/all")
    public String all(Model model) {
        List<Company> companyList = companyService.getAllCompanies();
        model.addAttribute("list", companyList);
        return "company/all";
    }

    @GetMapping("/get/{companyId}")
    public String get(@PathVariable Long companyId, Model model) {
        model.addAttribute("company", companyService.findById(companyId));
        return "company/company";
    }

    @GetMapping("/edit/{companyId}")
    public String update(@PathVariable Long companyId, Model model) {
        model.addAttribute("company", companyService.findById(companyId));
        return "company/edit";
    }

    @PostMapping("/edit")
    public String update(@Valid Company company , BindingResult bindingResult , Principal principal, Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("company", company);
            model.addAttribute("errors", bindingResult);
            return "company/edit";
        }
        companyService.editCompany(company);
        return "redirect:/company/all";
    }

    @PostMapping("/delete/{companyId}")
    public String delete(@PathVariable Long companyId, Principal principal , Model model) {
        if (companyService.checkAuthorityForDelete(principal.getName())){
            companyService.deleteCompany(companyId);
            return "redirect:/company/all";
        }
        return "redirect:/company/all";
    }

}
