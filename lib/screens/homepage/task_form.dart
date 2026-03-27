import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../controllers/task_controller.dart';
import '../../models/task_model.dart';
import '../../controllers/theme_controller.dart';

class TaskFormModal extends StatefulWidget {
  final Task? task;
  const TaskFormModal({super.key, this.task});

  @override
  State<TaskFormModal> createState() => _TaskFormModalState();
}

class _TaskFormModalState extends State<TaskFormModal> {
  final controller = Get.find<TaskController>();
  final themeController = Get.find<ThemeController>();
  final box = GetStorage();

  late TextEditingController titleController;
  late TextEditingController descController;
  DateTime selectedDate = DateTime.now();
  TaskStatus selectedStatus = TaskStatus.todo;
  String? blockedById;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task?.title ?? box.read('draft_title') ?? "");
    descController = TextEditingController(text: widget.task?.description ?? box.read('draft_desc') ?? "");
    if (widget.task != null) {
      selectedDate = widget.task!.dueDate;
      selectedStatus = widget.task!.status;
      blockedById = widget.task!.blockedBy;
    }
  }

  void _saveDrafts() {
    if (widget.task == null) {
      controller.saveDraft(titleController.text, descController.text);
    }
  }

  bool get isDark => themeController.isDarkMode.value;
  Color get bgColor => isDark ? const Color(0xff1E1E1E) : Colors.white;
  Color get inputBgColor => isDark ? const Color(0xff2A2A2A) : const Color(0xffF8F9FA);
  Color get textColor => isDark ? Colors.white : const Color(0xff2A0A4A);
  Color get subTextColor => isDark ? Colors.grey[400]! : Colors.grey[600]!;
  Color get borderColor => isDark ? Colors.grey.shade800 : Colors.grey.shade200;
  Color get focusedBorderColor => isDark ? const Color(0xffE0AAFF) : const Color(0xff7b2cbf);
  Color get iconColor => isDark ? const Color(0xffE0AAFF) : const Color(0xff3c096c);
  Color get gradientStart => isDark ? const Color(0xff120324) : const Color(0xff3c096c);
  Color get gradientEnd => isDark ? const Color(0xff2a0a4a) : const Color(0xff7b2cbf);
  Color get shadowColor => isDark ? const Color(0xffc77dff).withOpacity(0.2) : const Color(0xff7b2cbf).withOpacity(0.4);

  InputDecoration _customInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(fontFamily: 'Poppins', color: subTextColor),
      filled: true,
      fillColor: inputBgColor, 
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: focusedBorderColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableBlockers = controller.tasks.where((t) => t.id != widget.task?.id).toList();

    return Obx(() => Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 30,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Swipe/Drag Handle
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[700] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text(
                widget.task == null ? "Create New Task" : "Edit Task",
                style: TextStyle(
                  fontFamily: 'Poppins', 
                  fontSize: 24, 
                  fontWeight: FontWeight.w800, 
                  color: textColor
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0, duration: 400.ms, curve: Curves.easeOutBack),
              const SizedBox(height: 24),
              
              TextField(
                controller: titleController,
                onChanged: (_) => _saveDrafts(),
                style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500, color: textColor),
                decoration: _customInputDecoration("Task Title"),
              ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideX(begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOutQuad),
              
              const SizedBox(height: 16),
              
              TextField(
                controller: descController,
                onChanged: (_) => _saveDrafts(),
                maxLines: 3,
                style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: textColor),
                decoration: _customInputDecoration("Description"),
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideX(begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOutQuad),
              
              const SizedBox(height: 16),
              
              Container(
                decoration: BoxDecoration(
                  color: inputBgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<TaskStatus>(
                    value: selectedStatus,
                    icon: Icon(Icons.arrow_drop_down_rounded, color: iconColor),
                    dropdownColor: bgColor,
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 15, color: textColor, fontWeight: FontWeight.w600),
                    isExpanded: true,
                    items: TaskStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.name.toUpperCase()))).toList(),
                    onChanged: (val) => setState(() => selectedStatus = val!),
                  ),
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideX(begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOutQuad),
              
              const SizedBox(height: 16),
              
              if (availableBlockers.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: inputBgColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor, width: 1.5),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      value: blockedById,
                      icon: const Icon(Icons.lock_rounded, color: Colors.redAccent, size: 20),
                      dropdownColor: bgColor,
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 15, color: textColor, fontWeight: FontWeight.w500),
                      isExpanded: true,
                      hint: Text("Blocked By (None)", style: TextStyle(fontFamily: 'Poppins', color: subTextColor)),
                      items: [
                        const DropdownMenuItem(value: null, child: Text("None")),
                        ...availableBlockers.map((t) => DropdownMenuItem(value: t.id, child: Text(t.title)))
                      ],
                      onChanged: (val) => setState(() => blockedById = val),
                    ),
                  ),
                ).animate().fadeIn(delay: 400.ms, duration: 400.ms).slideX(begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOutQuad),
              
              const SizedBox(height: 32),
              
              // Actions
              Row(
                mainAxisAlignment: widget.task != null ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                children: [
                  if (widget.task != null)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(isDark ? 0.2 : 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.delete_outline_rounded, color: isDark ? Colors.redAccent : Colors.red, size: 28),
                        onPressed: controller.isLoading.value ? null : () {
                          controller.deleteTask(widget.task!.id);
                          Get.back();
                        }
                      ),
                    ).animate().fadeIn(delay: 500.ms).scale(duration: 400.ms, curve: Curves.easeOutBack),

                  if (widget.task != null) const SizedBox(width: 16),

                  Expanded(
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [gradientStart, gradientEnd],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor,
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: controller.isLoading.value ? null : () {
                            if (titleController.text.trim().isEmpty) {
                              Get.snackbar(
                                "Error", 
                                "Title cannot be empty", 
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: isDark ? const Color(0xff441111) : Colors.redAccent,
                                colorText: Colors.white,
                                margin: const EdgeInsets.all(16),
                                borderRadius: 12,
                              );
                              return;
                            }

                            final newTask = Task(
                              id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                              title: titleController.text.trim(),
                              description: descController.text.trim(),
                              dueDate: selectedDate,
                              status: selectedStatus,
                              blockedBy: blockedById,
                            );
                            controller.addOrUpdateTask(newTask, isEdit: widget.task != null);
                          },
                          child: Center(
                            child: controller.isLoading.value
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(widget.task == null ? Icons.add_task_rounded : Icons.save_rounded, color: Colors.white),
                                      const SizedBox(width: 8),
                                      Text(
                                        widget.task == null ? "CREATE TASK" : "SAVE UPDATES", 
                                        style: const TextStyle(
                                          color: Colors.white, 
                                          fontWeight: FontWeight.w700, 
                                          fontFamily: 'Poppins',
                                          fontSize: 16,
                                          letterSpacing: 0.5,
                                        )
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 500.ms).scale(duration: 400.ms, curve: Curves.easeOutBack),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}