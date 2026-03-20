# Fonde UI Design Guidelines

Fonde UI is a desktop-first Flutter UI component library. This document provides design guidelines for using and developing Fonde UI.

## Design Principles

**Desktop-First** — Optimized for desktop applications (macOS, Windows, Linux). Mouse and keyboard are the primary input methods.

**Accessibility over aesthetics** — Visibility and perceivability take priority over visual beauty in all component design decisions. When a design option is more beautiful but harder to perceive (e.g. low-contrast, thin strokes, outline-only indicators), the more accessible option is the default.

**Animation policy** — Whether to use animation is decided by accessibility, not aesthetics. Animations that delay response to user input (ripple effects, tab switching, etc.) are disabled. Animations that aid state recognition (progress indicators, overlay transitions) are permitted. Reduced-motion and high-contrast contexts minimize or eliminate motion.

For the full priority order applied to individual component decisions, see [01. Basic Concepts and Principles](./01-foundations.md).

## Document Structure

### Fundamentals

- **[01. Basic Concepts and Principles](./01-foundations.md)** — Design principles, architecture, core philosophy
- **[02. Design Tokens](./02-design-tokens.md)** — Colors, spacing, typography, borders, etc.

### Implementation

- **[03. Component Specifications](./03-components.md)** — Detailed specifications for each UI component
- **[04. Implementation Guide](./04-implementation.md)** — Implementation methods, best practices

### Specialized Areas

- **[05. Accessibility](./05-accessibility.md)** — Accessibility support, zoom functionality
- **[06. Development Tools](./06-development.md)** — Catalog app, testing, development environment
- **[07. Button Roles and Sizing](./07-button-roles-and-sizing.md)** — Button roles, size specifications
- **[08. MasterDetailLayout Design Specification](./08-master-detail-layout.md)** — Master-detail pattern specifications
- **[09. Color Design Guidelines](./09-color-design-guidelines.md)** — Preset theme design rules
- **[10. Table View (FondeTableView)](./10-table-view-guidelines.md)** — Table view component specifications
- **[12. Theme Colors](./12-theme-color.md)** — Theme color palette definitions
- **[13. Panel Layout Design Guidelines](./13-panel-layout-guidelines.md)** — Dialog/panel 3-layer structure, padding specifications
- **[14. Container-Content Separation Design Principles](./14-container-content-separation.md)** — UI element classification, padding strategy
- **[15. Warning/Confirmation Dialog Guidelines](./15-warning-error-dialog-guidelines.md)** — Confirmation and error dialog design specifications

## Quick Start

### For New Developers

1. Read [01. Basic Concepts and Principles](./01-foundations.md) to grasp the overall picture
2. Learn about spacing and color usage in [02. Design Tokens](./02-design-tokens.md)
3. Confirm specific implementation methods in [03. Component Specifications](./03-components.md)

### For Existing Developers

- Specific component specifications: [03. Component Specifications](./03-components.md)
- Problem-solving during implementation: [04. Implementation Guide](./04-implementation.md)
- Accessibility support: [05. Accessibility](./05-accessibility.md)

---

**Navigation**: [Next: Basic Concepts and Principles →](./01-foundations.md)
