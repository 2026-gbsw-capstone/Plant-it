package dev.siyoung.plantit.plantitbe.contorller;

import dev.siyoung.plantit.plantitbe.dto.admin.AiPromptFormDto;
import dev.siyoung.plantit.plantitbe.dto.admin.PlantCareGuideFormDto;
import dev.siyoung.plantit.plantitbe.entity.AiPrompt;
import dev.siyoung.plantit.plantitbe.entity.AiPrompt.PromptType;
import dev.siyoung.plantit.plantitbe.entity.PlantCareGuide;
import dev.siyoung.plantit.plantitbe.config.AdminAuthInterceptor;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import dev.siyoung.plantit.plantitbe.service.AdminDbService;
import dev.siyoung.plantit.plantitbe.service.AdminPlantCareGuideService;
import dev.siyoung.plantit.plantitbe.service.AiPromptService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminController {
    private final AdminPlantCareGuideService adminPlantCareGuideService;
    private final AdminDbService adminDbService;
    private final AiPromptService aiPromptService;

    @Value("${admin.username}")
    private String adminUsername;

    @Value("${admin.password}")
    private String adminPassword;

    @GetMapping("/login")
    public String loginForm() {
        return "admin/login";
    }

    @PostMapping("/login")
    public String login(HttpServletRequest request, Model model) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (adminPassword != null && !adminPassword.isBlank()
                && adminUsername.equals(username)
                && adminPassword.equals(password)) {
            request.getSession(true).setAttribute(AdminAuthInterceptor.ADMIN_LOGIN_SESSION_KEY, true);
            return "redirect:/admin/guides";
        }

        model.addAttribute("error", true);
        return "admin/login";
    }

    @PostMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/admin/login";
    }

    @GetMapping
    public String index() {
        return "redirect:/admin/guides";
    }

    @GetMapping("/guides")
    public String guides(Model model) {
        List<PlantCareGuide> guides = adminPlantCareGuideService.findAll();
        model.addAttribute("guides", guides);
        model.addAttribute("hasGuides", !guides.isEmpty());
        return "admin/guides/list";
    }

    @GetMapping("/db/{table}")
    public String dbTable(@PathVariable String table, Model model) {
        model.addAttribute("data", adminDbService.getTable(table));
        return "admin/db/list";
    }

    @GetMapping("/prompts")
    public String prompts(Model model) {
        List<AiPrompt> prompts = aiPromptService.findAll();
        model.addAttribute("prompts", prompts);
        model.addAttribute("hasPrompts", !prompts.isEmpty());
        return "admin/prompts/list";
    }

    @GetMapping("/prompts/{promptType}/edit")
    public String editPrompt(@PathVariable PromptType promptType, Model model) {
        AiPrompt prompt = aiPromptService.findByType(promptType);
        model.addAttribute("prompt", prompt);
        model.addAttribute("form", aiPromptService.toForm(prompt));
        model.addAttribute("action", "/admin/prompts/" + promptType);
        return "admin/prompts/form";
    }

    @PostMapping("/prompts/{promptType}")
    public String updatePrompt(@PathVariable PromptType promptType,
                               @Valid @ModelAttribute("form") AiPromptFormDto form,
                               BindingResult bindingResult,
                               Model model) {
        AiPrompt prompt = aiPromptService.findByType(promptType);
        if (bindingResult.hasErrors()) {
            model.addAttribute("prompt", prompt);
            model.addAttribute("action", "/admin/prompts/" + promptType);
            model.addAttribute("hasErrors", true);
            return "admin/prompts/form";
        }

        aiPromptService.update(promptType, form);
        return "redirect:/admin/prompts";
    }

    @PostMapping("/db/{table}/{id}/delete")
    public String deleteDbRow(@PathVariable String table, @PathVariable Long id) {
        adminDbService.delete(table, id);
        return "redirect:/admin/db/" + table;
    }

    @GetMapping("/guides/new")
    public String newGuide(Model model) {
        model.addAttribute("form", new PlantCareGuideFormDto());
        model.addAttribute("mode", "create");
        model.addAttribute("action", "/admin/guides");
        return "admin/guides/form";
    }

    @PostMapping("/guides")
    public String createGuide(@Valid @ModelAttribute("form") PlantCareGuideFormDto form,
                              BindingResult bindingResult,
                              Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("mode", "create");
            model.addAttribute("action", "/admin/guides");
            model.addAttribute("hasErrors", true);
            return "admin/guides/form";
        }

        PlantCareGuide guide = adminPlantCareGuideService.create(form);
        return "redirect:/admin/guides/" + guide.getId();
    }

    @GetMapping("/guides/{guideId}")
    public String guideDetail(@PathVariable Long guideId, Model model) {
        model.addAttribute("guide", adminPlantCareGuideService.findById(guideId));
        return "admin/guides/detail";
    }

    @GetMapping("/guides/{guideId}/edit")
    public String editGuide(@PathVariable Long guideId, Model model) {
        PlantCareGuide guide = adminPlantCareGuideService.findById(guideId);
        model.addAttribute("form", adminPlantCareGuideService.toForm(guide));
        model.addAttribute("mode", "edit");
        model.addAttribute("guideId", guideId);
        model.addAttribute("action", "/admin/guides/" + guideId);
        return "admin/guides/form";
    }

    @PostMapping("/guides/{guideId}")
    public String updateGuide(@PathVariable Long guideId,
                              @Valid @ModelAttribute("form") PlantCareGuideFormDto form,
                              BindingResult bindingResult,
                              Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("mode", "edit");
            model.addAttribute("guideId", guideId);
            model.addAttribute("action", "/admin/guides/" + guideId);
            model.addAttribute("hasErrors", true);
            return "admin/guides/form";
        }

        adminPlantCareGuideService.update(guideId, form);
        return "redirect:/admin/guides/" + guideId;
    }

    @PostMapping("/guides/{guideId}/delete")
    public String deleteGuide(@PathVariable Long guideId) {
        adminPlantCareGuideService.delete(guideId);
        return "redirect:/admin/guides";
    }
}
