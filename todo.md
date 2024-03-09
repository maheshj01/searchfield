[] offsets 4 tests failing
[] Textcontroller used after dispose (on widget tree changed)
[X] Investigate onFieldSubmitted and onSuggestionTap are conflicting

[ ] SuggestionDirection.up

- [ ] Test that the suggestions are displayed above the textfield in reverse order
- [ ] Arrow keys should navigate suggestions in correct order
- [ ] emptyWidget should be displayed in the overlay

<!-- Focus -->

1. Widget should have focus when pressed Tab
2. Enter key should show suggestions
3. Arrow keys should navigate suggestions
4. Enter key should select suggestion
5. Tab key should navigate suggestions if expanded
6. Shift+Tab key should navigate suggestions backwards
7. Escape key should close suggestions
8. Arrow keys should navigate suggestions
9. Enter key should select suggestion
10. Tab key should shift focus to next widget if not expanded
11. Shift+Tab key should shift focus to previous widget if not expanded
12. Escape key should close suggestions if expanded
