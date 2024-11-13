import Data.Char (isAlpha, isAlphaNum, isLower, isUpper)
--a maior tristeza desse desafio é que eu consegui resolver ele, mas importando parsec
-- Definição dos tipos
data Term = Var String | Const String | Fun String [Term] deriving (Eq, Show)
type Substitution = [(String, Term)]

-- Tokenização o unico problema que tive KKKKKKKKKK
tokenize :: String -> [String]
tokenize [] = []
tokenize (c:cs)
    | c `elem` "()," = [c] : tokenize cs
    | isAlpha c = let (name, rest) = span isAlphaNum (c:cs) in name : tokenize rest
    | otherwise = tokenize cs

-- Parsing principal
parseTerm :: [String] -> Either String (Term, [String])
parseTerm (t:ts)
    | isLower (head t) = Right (Var t, ts)           -- Variável
    | isUpper (head t) = Right (Const t, ts)         -- Constante
    | otherwise = case ts of
        "(":rest -> do
            (args, rest') <- parseArgs rest          -- Parênteses de função
            case rest' of
                ")":remaining -> Right (Fun t args, remaining)
                _ -> Left "Erro de sintaxe: esperado ')' após os argumentos"
        _ -> Left "Erro de sintaxe: esperado '(' após o nome da função"
parseTerm [] = Left "Erro de sintaxe: entrada vazia"

-- Parsing dos argumentos da função
parseArgs :: [String] -> Either String ([Term], [String])
parseArgs (")":rest) = Right ([], rest)              -- Nenhum argumento, lista vazia
parseArgs ts = do
    (term, rest) <- parseTerm ts
    case rest of
        ",":rest' -> do
            (terms, rest'') <- parseArgs rest'
            Right (term : terms, rest'')
        ")":rest' -> Right ([term], rest')
        _ -> Left "Erro de sintaxe nos argumentos"

-- Aplicação de Substituições
applySubst :: Substitution -> Term -> Term
applySubst s (Var v) = maybe (Var v) id (lookup v s)
applySubst s (Fun f args) = Fun f (map (applySubst s) args)
applySubst _ t = t

-- Composição de Substituições
compose :: Substitution -> Substitution -> Substitution
compose s1 s2 = [(v, applySubst s1 t) | (v, t) <- s2] ++ s1

-- Algoritmo de Unificação
unify :: Term -> Term -> Either String Substitution
unify (Var v) t = if occursCheck v t then Left "Falha na verificação de ocorrência" else Right [(v, t)]
unify t (Var v) = unify (Var v) t
unify (Const c1) (Const c2)
    | c1 == c2 = Right []
    | otherwise = Left "Constantes diferentes"
unify (Fun f1 args1) (Fun f2 args2)
    | f1 /= f2 || length args1 /= length args2 = Left "Funções diferentes ou número de argumentos diferentes"
    | otherwise = unifyArgs args1 args2
unify _ _ = Left "Não unificável"

-- Unificação dos argumentos das funções
unifyArgs :: [Term] -> [Term] -> Either String Substitution
unifyArgs [] [] = Right []
unifyArgs (x:xs) (y:ys) = do
    s1 <- unify x y
    s2 <- unifyArgs (map (applySubst s1) xs) (map (applySubst s1) ys)
    Right (compose s1 s2)
unifyArgs _ _ = Left "Número de argumentos incompatível"

-- Verificação de Ocorrências
occursCheck :: String -> Term -> Bool
occursCheck v (Var v') = v == v'
occursCheck v (Fun _ args) = any (occursCheck v) args
occursCheck _ _ = False

-- Função Principal para Leitura e Execução
main :: IO ()
main = do
    putStrLn "Termo 1:"
    input1 <- getLine
    putStrLn "Termo 2:"
    input2 <- getLine
    let parsedTerm1 = parseTerm (tokenize input1)
        parsedTerm2 = parseTerm (tokenize input2)
    case (parsedTerm1, parsedTerm2) of
        (Right (term1, []), Right (term2, [])) -> case unify term1 term2 of
            Right subst -> putStrLn $ "Unificável com substituições: " ++ show subst
            Left err -> putStrLn $ "Não unificável: " ++ err
        (Right (_, leftover), _) | not (null leftover) -> putStrLn "Erro de sintaxe no Termo 1: entrada inválida"
        (_, Right (_, leftover)) | not (null leftover) -> putStrLn "Erro de sintaxe no Termo 2: entrada inválida"
        (Left err, _) -> putStrLn $ "Erro de sintaxe no Termo 1: " ++ err
        (_, Left err) -> putStrLn $ "Erro de sintaxe no Termo 2: " ++ err