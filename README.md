# Comparativo de Prescritores

Site estático (sem build) com login e banco de dados no Supabase. Cada usuário vê apenas as próprias planilhas e não há cadastro público: os usuários entram por convite.

## 1. Supabase

1. Crie um projeto em <https://supabase.com>.
2. **SQL Editor → New query**: cole o conteúdo de [supabase/schema.sql](supabase/schema.sql) e clique em **Run**.
3. **Authentication → Sign In / Providers**:
   - desligue **Allow new users to sign up** (é o que deixa o acesso só para convidados);
   - deixe **Email** habilitado.
4. **Authentication → URL Configuration**:
   - **Site URL**: a URL da Vercel (ex.: `https://comparativo-prescritores.vercel.app`);
   - **Redirect URLs**: a mesma URL e também `http://localhost:3000` se for testar localmente.
5. **Project Settings → API**: copie a **Project URL** e a chave **anon / publishable** para o [config.js](config.js).

> A chave anon é pública por natureza. Quem protege os dados são as políticas RLS criadas pelo `schema.sql`. **Nunca** coloque a chave `service_role` no `config.js`.

## 2. Usuários

**Authentication → Users → Invite user** e informe o e-mail. A pessoa recebe um link, abre o site, define a senha e já entra.

Se alguém esquecer a senha, basta usar "Esqueci minha senha" na tela de login.

> O e-mail padrão do Supabase tem limite baixo de envios por hora. Para uso em produção, configure um SMTP próprio em **Project Settings → Authentication → SMTP Settings**.

## 3. Deploy na Vercel

- Pelo terminal: `npx vercel` nesta pasta.
- Pelo GitHub: importe o repositório, escolha **Framework Preset: Other** e deixe os comandos de build e output em branco.

O `.vercelignore` deixa fora do deploy a planilha de exemplo (`uploads/`), o `seed.json` e o SQL.

## Testar localmente

```sh
npx serve -l 3000 .
```
