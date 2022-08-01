use heraclitus_compiler::prelude::*;
use crate::parser::ParserMetadata;
use super::literal::{
    bool::Bool,
    number::Number,
    text::Text
};
use super::binop::{
    add::Add,
    sub::Sub,
    mul::Mul,
    div::Div
};
use super::parenthesis::Parenthesis;

#[derive(Debug, Clone)]
pub enum ExprId {
    Bool,
    Number,
    Text,
    Parenthesis,
    Add,
    Sub,
    Mul,
    Div
}

#[derive(Debug)]
pub enum ExprType {
    Bool(Bool),
    Number(Number),
    Text(Text),
    Parenthesis(Parenthesis),
    Add(Add),
    Sub(Sub),
    Mul(Mul),
    Div(Div)
}

#[derive(Debug)]
pub struct Expr {
    value: Option<ExprType>
}

impl Expr {
    fn statement_types(&self) -> Vec<ExprType> {
        vec![
            ExprType::Add(Add::new()),
            ExprType::Sub(Sub::new()),
            ExprType::Mul(Mul::new()),
            ExprType::Div(Div::new()),
            ExprType::Parenthesis(Parenthesis::new()),
            ExprType::Bool(Bool::new()),
            ExprType::Number(Number::new()),
            ExprType::Text(Text::new())
        ]
    }
    
    fn parse_statement(&mut self, meta: &mut ParserMetadata, statement: ExprType) -> SyntaxResult {
        match statement {
            ExprType::Bool(bool) => self.get(meta, bool, ExprType::Bool, ExprId::Bool),
            ExprType::Number(num) => self.get(meta, num, ExprType::Number, ExprId::Number),
            ExprType::Text(txt) => self.get(meta, txt, ExprType::Text, ExprId::Text),
            ExprType::Parenthesis(p) => self.get(meta, p, ExprType::Parenthesis, ExprId::Parenthesis),
            ExprType::Add(add) => self.get(meta, add, ExprType::Add, ExprId::Add),
            ExprType::Sub(sub) => self.get(meta, sub, ExprType::Sub, ExprId::Sub),
            ExprType::Mul(mul) => self.get(meta, mul, ExprType::Mul, ExprId::Mul),
            ExprType::Div(div) => self.get(meta, div, ExprType::Div, ExprId::Div)
        }
    }

    // Get result out of the provided module and save it in the internal state
    fn get<S>(&mut self, meta: &mut ParserMetadata, mut module: S, cb: impl Fn(S) -> ExprType, id: ExprId) -> SyntaxResult
    where
        S: SyntaxModule<ParserMetadata>
    {
        // Match syntax
        match syntax(meta, &mut module) {
            Ok(()) => {
                self.value = Some(cb(module));
                Ok(())    
            }
            Err(details) => Err(details)
        }
    }
}

impl SyntaxModule<ParserMetadata> for Expr {
    fn new() -> Self {
        Expr {
            value: None
        }
    }

    fn parse(&mut self, meta: &mut ParserMetadata) -> SyntaxResult {
        let mut error = None;
        let statements = self.statement_types();
        for statement in statements {
            match self.parse_statement(meta, statement) {
                Ok(()) => return Ok(()),
                Err(details) => error = Some(details)
            }
        }
        Err(error.unwrap())
    }
}
