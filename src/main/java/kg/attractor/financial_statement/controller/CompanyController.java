package kg.attractor.financial_statement.controller;

import jakarta.validation.Valid;
import kg.attractor.financial_statement.dto.CompanyDto;
import kg.attractor.financial_statement.service.CompanyService;
import kg.attractor.financial_statement.service.UserService;
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
    private final UserService userService;

    @PostMapping("/create")
    @ResponseBody
    public ResponseEntity<Map<String, String>> create(
            @Valid CompanyDto companyDto,
            BindingResult bindingResult,
            Principal principal) {
        return companyService.createCompany(companyDto, principal.getName(), bindingResult);
    }


    @GetMapping("/all/")
    public String getAll(
            @RequestParam(required = false, defaultValue = "0") Long companyId,
            @RequestParam(required = false, defaultValue = "0") int page,
            @RequestParam(required = false, defaultValue = "10") int size,
            @RequestParam(value = "sort", defaultValue = "actual") String sort,
            Model model, Principal principal) {

        List<CompanyDto> allCompanies = companyService.getAllCompaniesBySort(sort);
        int totalCompanies = allCompanies.size();
        int start = page * size;
        int end = Math.min(start + size, totalCompanies);

        model.addAttribute("list", allCompanies.subList(start, end));

        if (companyId != 0) {
            model.addAttribute("company", companyService.findById(companyId));
            model.addAttribute("companyId", companyId);
        } else if (allCompanies.isEmpty()) {
            model.addAttribute("company", new CompanyDto());
            model.addAttribute("companyId", companyId);
        } else {
            model.addAttribute("company", allCompanies.getFirst());
            model.addAttribute("companyId", allCompanies.getFirst().getId());
        }

        boolean isAdmin = false;
        if (principal != null) {
            isAdmin = userService.isAdmin(principal.getName());
        }
        model.addAttribute("isAdmin", isAdmin);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", (int) Math.ceil((double) totalCompanies / size));
        model.addAttribute("sort", sort);

        return "company/all";
    }


    @PostMapping("/edit")
    @ResponseBody
    public ResponseEntity<Map<String, String>> update(@RequestBody Map<String, String> data) {
        return companyService.editByOne(data);
    }

    @PostMapping("/delete")
    public String deleteById(@RequestParam Long companyId) {
        companyService.deleteCompany(companyId);
        return "redirect:/company/all/";
    }

    @PostMapping("/return")
    public String returnById(@RequestParam Long companyId) {
        companyService.returnCompany(companyId);
        return "redirect:/company/all/";
    }

}
