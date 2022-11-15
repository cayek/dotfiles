;;; ../../dotfiles2/.config/doom/packages.d/cc.el -*- lexical-binding: t; -*-

(after! lsp-mode
  (setq lsp-pylsp-plugins-flake8-enabled t
        lsp-pylsp-plugins-autopep8-enabled t
        lsp-diagnostics--flycheck-enabled t
        lsp-ui-doc-enable nil
        lsp-ui-sideline-show-diagnostics nil
        lsp-ui-peek-enable nil
        lsp-signature-render-documentation nil
        ))

(use-package! sphinx-doc
  :hook (python-mode . sphinx-doc-mode))

(setq-default flycheck-disabled-checkers '(c/c++-gcc))

(after! realgud
  (require 'realgud-lldb)
  )


(setq lsp-ui-sideline-mode nil)
(setq lsp-lens-enable nil)
