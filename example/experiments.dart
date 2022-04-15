// ######################
// TEST
// ######################

import 'dart:io';

// import 'package:analyzer/dart/analysis/features.dart';
// import 'package:analyzer/dart/analysis/utilities.dart';
// import 'package:analyzer/dart/ast/ast.dart';
// import 'package:analyzer/dart/ast/ast_factory.dart';
// import 'package:analyzer/dart/ast/standard_ast_factory.dart';
// import 'package:analyzer/dart/ast/token.dart';
// import 'package:analyzer/dart/ast/visitor.dart';
// import 'package:analyzer/src/dart/ast/utilities.dart';

// import 'package:analyzer/dart/ast/ast.dart';
// import 'package:analyzer/dart/element/element.dart';
// import 'package:analyzer/dart/element/scope.dart';
// import 'package:analyzer/dart/element/type.dart';
// import 'package:analyzer/dart/element/type_provider.dart';
// import 'package:analyzer/error/listener.dart';
// import 'package:analyzer/file_system/file_system.dart';
// import 'package:analyzer/src/dart/ast/ast.dart';
// import 'package:analyzer/src/dart/ast/utilities.dart';
// import 'package:analyzer/src/error/codes.dart';

import 'package:dart_style/dart_style.dart';

main() {
  final ggFormatter = DartFormatter(useGgModifications: true);
  final defaultFormatter = DartFormatter(useGgModifications: false);

  try {
    final source =
        File('/Users/gatzsche/dev/sandbox/ast_experiments/bin/sample.dart')
            .readAsStringSync();
    final fixedSource = ggFormatter.format(source);
    final formattedSource = defaultFormatter.format(fixedSource);
    print(formattedSource);
  } on FormatterException catch (ex) {
    print(ex);
  }

  return;

//  try {
//    // Create the sample AST
//    final template = expectThrowTemplate();
//
//    // Read the wrong AST
//    var oldAst = parseFile(
//      path: '/Users/gatzsche/dev/sandbox/ast_experiments/bin/sample.dart',
//      featureSet: FeatureSet.latestLanguageVersion(),
//    );
//
//    // Iterate the wrong AST and replace the try catch clause
//    oldAst.unit.visitChildren(TryCatchVisitor(
//      didFindException: (tryCatchBlock, throwingCode, expectedException) {
//        final replacer = NodeReplacer(tryCatchBlock, template);
//        tryCatchBlock.parent!.accept(replacer);
//        // Todo: Replace tryCatchBloc with template
//      },
//    ));
//  } catch (error) {
//    print(error);
//  }
//
//  /* var ast = parseCompilationUnit(src, parseFunctionBodies: true);
//  print('initial value: ');
//  print(ast.toSource());
//  var v = Visitor();
//  ast.visitChildren(v);
//  print('After modification:');
//  print(ast.toSource());*/
}

// #############################################################################
/* class ExpectExceptionVisitor<R> extends GeneralizingAstVisitor<R> {
  late FunctionExpression result;

  @override
  R? visitFunctionExpression(FunctionExpression node) {
    result = node;
    return super.visitFunctionExpression(node);
  }
}

// #############################################################################
FunctionExpression expectThrowTemplate() {
  final expectExceptionTemplate = '''
    import 'package:test/expect.dart';
    import 'package:test/scaffolding.dart';

    main() {
      test('test', () {
        expect(() {
          throw (AssertionError('Hello'));
        }, throwsA(isA<AssertionError>()));
      });
    }
  ''';

  var templateAst = parseString(
    content: expectExceptionTemplate,
    featureSet: FeatureSet.latestLanguageVersion(),
  );

  final visitor = ExpectExceptionVisitor();
  templateAst.unit.visitChildren(visitor);
  return visitor.result;
}

typedef DidFindException = Function(
    AstNode tryCatchBlock, Block throwingCode, NamedType expectedException);

// #############################################################################
class TryCatchVisitor<R> extends GeneralizingAstVisitor<R> {
  TryCatchVisitor({required this.didFindException});

  final DidFindException didFindException;

  var resultString = '';

  // ...........................................................................
  T? child<T>(AstNode? node, int at) {
    if (node == null) {
      return null;
    }

    if (at >= node.childEntities.length) {
      return null;
    }

    final result = node.childEntities.elementAt(at);
    if (result is T) {
      return result as T;
    }

    return null;
  }

  // ...........................................................................
  @override
  R? visitNode(AstNode node) {
    node.toString();
    // TODO: implement visitNode
    for (final c in node.childEntities) {
      if (c is Token) {
        resultString += c.toString();
        resultString += ' ';
        print(resultString);
      } else if (c is Statement) {
        visitStatement(c);
      } else if (c is AstNode) {
        super.visitNode(node);
      }
    }

    return null;
  }

  // ...........................................................................
  @override
  R? visitStatement(Statement node) {
    for (final c in node.childEntities) {
      if (c is Token) {
        resultString += c.toString();
        print(resultString);
      } else if (c is Statement) {
        visitStatement(c);
      } else if (c is AstNode) {
        super.visitNode(node);
      }
    }
  }

  // ...........................................................................
  // Let's search for try catch statements here
  @override
  R? visitTryStatement(TryStatement tryCatchBlock) {
    final throwingCode = child<Block>(tryCatchBlock, 1);
    final catchClause = child<CatchClause>(tryCatchBlock, 2);
    final block = child<Block>(catchClause, 6);
    final expression = child<ExpressionStatement>(block, 1);
    final methodInvocation = child<MethodInvocation>(expression, 0);
    final argumentList = child<ArgumentList>(methodInvocation, 1);
    final isExpression = child<IsExpression>(argumentList, 1);
    final errorType = child<NamedType>(isExpression, 2);
    if (errorType != null && throwingCode != null) {
      didFindException(tryCatchBlock, throwingCode, errorType);
    }

    final x = visitTryStatement(tryCatchBlock);
  }

  /*//filter
    var p = new RegExp(r'.*\.on\(\w\)');
    if (!p.hasMatch(node.toString())) return;

    //replace
    SimpleStringLiteral ssl = _create_SimpleStringLiteral(node);
    node.parent.accept(new NodeReplacer(node, ssl));*/

}*/
