//
//  ColorSyntaxRewriter.swift
//  AbsoluteHSB
//
//  Created by 藤井陽介 on 2019/03/23.
//

import Foundation
import SwiftSyntax

internal class ColorSyntaxRewriter: SyntaxRewriter {

    override func visit(_ node: InitializerClauseSyntax) -> Syntax {

        return ColorInitializerSyntaxRewriter().visit(node)
    }
}

private class ColorInitializerSyntaxRewriter: SyntaxRewriter {

    override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {

        guard node.calledExpression.description == "UIColor"
            || node.calledExpression.description == "UIColor.init" else {

                return node
        }

        var color = HSBColor()
        node.argumentList.forEach { argumentSyntax in
            guard let label = argumentSyntax.label else {
                return
            }

            switch label.text {
            case "red":
                color.red = CGFloat(argumentSyntax.expression.description)
            case "green":
                color.green = CGFloat(argumentSyntax.expression.description)
            case "blue":
                color.blue = CGFloat(argumentSyntax.expression.description)
            case "alpha":
                color.alpha = CGFloat(argumentSyntax.expression.description)
            case "white":
                color.white = CGFloat(argumentSyntax.expression.description)
            case "displayP3Red":
                color.displayP3Red = CGFloat(argumentSyntax.expression.description)
            default:
                break
            }
        }

        let colonWithSpace = SyntaxFactory.makeColonToken().withTrailingTrivia(
            Trivia(pieces: [TriviaPiece.spaces(1)])
        )
        let commaWithSpace = SyntaxFactory.makeCommaToken().withTrailingTrivia(
            Trivia(pieces: [TriviaPiece.spaces(1)])
        )

        let newArgumentList = SyntaxFactory.makeFunctionCallArgumentList([
            SyntaxFactory.makeFunctionCallArgument(
                label: SyntaxFactory.makeStringLiteral("hue"),
                colon: colonWithSpace,
                expression: SyntaxFactory.makeBlankFloatLiteralExpr().withFloatingDigits(SyntaxFactory.makeFloatingLiteral("\(color.hue)")),
                trailingComma: commaWithSpace),
            SyntaxFactory.makeFunctionCallArgument(
                label: SyntaxFactory.makeStringLiteral("saturation"),
                colon: colonWithSpace,
                expression: SyntaxFactory.makeBlankFloatLiteralExpr().withFloatingDigits(SyntaxFactory.makeFloatingLiteral("\(color.saturation)")),
                trailingComma: commaWithSpace),
            SyntaxFactory.makeFunctionCallArgument(
                label: SyntaxFactory.makeStringLiteral("brightness"),
                colon: colonWithSpace,
                expression: SyntaxFactory.makeBlankFloatLiteralExpr().withFloatingDigits(SyntaxFactory.makeFloatingLiteral("\(color.brightness)")),
                trailingComma: commaWithSpace),
            SyntaxFactory.makeFunctionCallArgument(
                label: SyntaxFactory.makeStringLiteral("alpha"),
                colon: colonWithSpace,
                expression: SyntaxFactory.makeBlankFloatLiteralExpr().withFloatingDigits(SyntaxFactory.makeFloatingLiteral("\(color.alpha ?? 1.0)")),
                trailingComma: nil),
            ])

        return node.withArgumentList(newArgumentList)
    }
}
