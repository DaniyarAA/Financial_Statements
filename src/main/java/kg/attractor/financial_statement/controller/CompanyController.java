package kg.attractor.financial_statement.controller;

import jakarta.validation.Valid;
import kg.attractor.financial_statement.dto.CompanyDto;
import kg.attractor.financial_statement.service.CompanyService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/company")
@RequiredArgsConstructor
public class CompanyController {
    private final CompanyService companyService;

    @GetMapping("/create")
    public String create(Model model) {
        model.addAttribute("company", new CompanyDto());
        return "company/create";
    }

    @PostMapping("/create")
    public String create(@Valid CompanyDto companyDto, BindingResult bindingResult, Model model, Principal principal) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("company", companyDto);
            model.addAttribute("errors", bindingResult);
            return "company/create";
        }
        companyService.createCompany(companyDto,principal.getName());
        return "redirect:/company/all";
    }

    @GetMapping("/all/")
    public String getAll(
            @RequestParam(required = false, defaultValue = "0") Long companyId,
            @RequestParam(required = false, defaultValue = "0") int page,
            @RequestParam(required = false, defaultValue = "10") int size,
            Model model) {

        List<CompanyDto> allCompanies = companyService.getAllCompanies();
        int totalCompanies = allCompanies.size();
        int start = page * size;
        int end = Math.min(start + size, totalCompanies);

        model.addAttribute("list", allCompanies.subList(start, end));
        model.addAttribute("companyId", companyId);

        if (companyId == 0) {
            model.addAttribute("company", new CompanyDto());
        } else {
            model.addAttribute("company", companyService.findById(companyId));
        }

        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", (int) Math.ceil((double) totalCompanies / size));
        return "company/all";
    }

    @GetMapping("/{companyId}")
    public String getById(@PathVariable Long companyId, Model model) {
        model.addAttribute("company", companyService.findById(companyId));
        return "company/company";
    }

    @GetMapping("/edit/{companyId}")
    public String updateById(@PathVariable Long companyId, Model model) {
        model.addAttribute("company", companyService.findById(companyId));
        return "company/edit";
    }

    @PostMapping("/edit")
    @ResponseBody
    public ResponseEntity<Map<String, String>> update(@RequestBody Map<String, String> data) {
        return companyService.editByOne(data);
    }

    @PostMapping("/edit/{companyId}")
    public String updateById(@PathVariable Long companyId, @Valid CompanyDto company, BindingResult bindingResult, Model model) {
        company.setId(companyId);
        if (bindingResult.hasErrors()) {
            model.addAttribute("company", company);
            model.addAttribute("errors", bindingResult);
            return "company/edit";
        }
        companyService.editCompany(company);
        return "redirect:/company/all";
    }

    @PostMapping("/delete")
    public String deleteById(@RequestParam Long companyId) {
        companyService.deleteCompany(companyId);
        return "redirect:/company/all";
    }

    @GetMapping("/delete")
    public String deletePage(Model model){
        model.addAttribute("list", companyService.getAllCompanies());
        return "company/delete";
    }

}
