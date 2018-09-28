package org.xtext.example.expressiondsl.tests

import org.xtext.example.expressiondsl.expressionDSL.And
import org.xtext.example.expressiondsl.expressionDSL.BinaryMinus
import org.xtext.example.expressiondsl.expressionDSL.BinaryPlus
import org.xtext.example.expressiondsl.expressionDSL.BooleanConstant
import org.xtext.example.expressiondsl.expressionDSL.Comparison
import org.xtext.example.expressiondsl.expressionDSL.ConstDef
import org.xtext.example.expressiondsl.expressionDSL.Exponent
import org.xtext.example.expressiondsl.expressionDSL.Expression
import org.xtext.example.expressiondsl.expressionDSL.FunctionDef
import org.xtext.example.expressiondsl.expressionDSL.IntConstant
import org.xtext.example.expressiondsl.expressionDSL.MulOrDiv
import org.xtext.example.expressiondsl.expressionDSL.Named
import org.xtext.example.expressiondsl.expressionDSL.Not
import org.xtext.example.expressiondsl.expressionDSL.Or
import org.xtext.example.expressiondsl.expressionDSL.StructDef
import org.xtext.example.expressiondsl.expressionDSL.SubFieldDef
import org.xtext.example.expressiondsl.expressionDSL.UnaryMinus
import org.xtext.example.expressiondsl.expressionDSL.UnaryPlus
import org.xtext.example.expressiondsl.expressionDSL.VariableDef
import org.xtext.example.expressiondsl.expressionDSL.VariableArrayOrFunctionRef

class TestUtils {
	
	static def String stringRepr(Expression e) {
		switch (e) {

			And	: '''(«e.left.stringRepr» AND «e.right.stringRepr»)'''
			Or	: '''(«e.left.stringRepr» OR «e.right.stringRepr»)'''

			Comparison: '''(«e.left.stringRepr» «e.op» «e.right.stringRepr»)'''

			BinaryPlus: '''(«e.left.stringRepr» + «e.right.stringRepr»)'''
			BinaryMinus: '''(«e.left.stringRepr» - «e.right.stringRepr»)'''

			MulOrDiv: '''(«e.left.stringRepr» «e.op» «e.right.stringRepr»)'''

			Exponent: '''(«e.left.stringRepr» ** «e.right.stringRepr»)'''

			VariableArrayOrFunctionRef : '''«e.ref.stringRepr»«IF (e.args.length  > 0) || (e.ref instanceof FunctionDef)»(«FOR param: e.args SEPARATOR ':'»«param.stringRepr»«ENDFOR»)«ENDIF»'''

			UnaryPlus: '''( +«e.expr.stringRepr»)'''
			UnaryMinus: '''( -«e.expr.stringRepr»)'''			
			Not: '''(NOT «e.expr.stringRepr»)'''

//			VariableOrArrayOrFunc: '''«e.value.stringRepr»'''
//			Named: '''«e.XXXYYY»'''
			IntConstant: '''«e.value»'''
			BooleanConstant: '''«e.value»'''
		}.toString
	}	
	
//	static def String stringRepr(VariableOrArrayOrFunc e){
//		'''«e.ref.stringRepr»
//			«IF (e.params.length > 0) || (e.ref instanceof FunctionDef)»
//				(«FOR param: e.params SEPARATOR ':'»«param.stringRepr»«ENDFOR»)
//			«ENDIF»'''
//	}

	static def String stringRepr(Named e) {
//		var ref = e.ref
		switch (e) {
			VariableDef	: e.name
			ConstDef	: e.name
			StructDef	: e.name
			SubFieldDef	: e.name
			FunctionDef	: e.name
		}
//		return 'PlaceHolder'

	}
}