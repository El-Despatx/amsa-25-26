# AMSA Slides (2025–2026)

Below are instructions on how to setup and contribute to the project.

## 🚀 Development

Install [Quarto](https://quarto.org/docs/get-started/). 

Run:
```bash
quarto preview
```

This will build the site and open a local preview in your browser. The preview auto-updates when you save changes.

## 💻 VS Code Integration

If the **Quarto extension** is installed on VSCode, the following commands are available:

* **Quarto: Edit in Visual Mode**
  Switch to visual editor which helps for using cool quarto features.

* **Quarto: Preview**
  Open a preview of the current `.qmd` file.

* **Quarto: Edit in Source Mode**
  Switch back to plain markdown editing.

## 📂 Project Structure

* **`index.qmd`**
  The **home page** of the course website. Contains links to each week and to additional resources.

* **`week0.qmd`, `week1.qmd`, `week2.qmd`, …**
  Each file corresponds to the slide deck for a given week of the course.

* **`references/`**
  Bibliography files for each week’s deck, named as `weekX.bib`.

* **`figures/`**
  All images and figures used in slides organized by weeks, e.g. `figures/week0/example.png`.

## ➕ Adding a New Week

When creating a new week of slides:

1. **Create the `.qmd` file**

   * Name it `weekX.qmd` (e.g. `week3.qmd`).
   * Add YAML metadata with the correct `subtitle`.
     Example:

     ```yaml
     ---
     subtitle: "Week 3: Whatever"
     ---
     ```

2. **Add references (optional)**

   * If the week uses references, create a file `references/weekX.bib` and point to it in the `.qmd` YAML:

     ```yaml
     bibliography: references/week3.bib
     ```
   * At the end of the `.qmd` file a references section, which automatically writes the used references:

   ```md
    ---

    ## References {.smaller footer=false}
   ```

3. **Add figures (optional)**

   * Place images in `figures/weekX/` and reference them in the slides:

     ```markdown
     ![](figures/week3/diagram.png){width=60%}
     ```

4. **Update the home page**

   * Edit `index.qmd` and add a link to the new week’s slides:

     ```markdown
     - [Week 3: Whatever](week3.qmd)
     ```

That’s it, now the new week will appear on the course homepage and be accessible as a slide deck.
