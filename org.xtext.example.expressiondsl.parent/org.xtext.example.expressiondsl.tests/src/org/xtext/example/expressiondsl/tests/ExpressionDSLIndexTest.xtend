package org.xtext.example.expressiondsl.tests

import com.google.inject.Inject
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

import static extension org.junit.Assert.*
import org.xtext.example.expressiondsl.expressionDSL.Model
import org.xtext.example.expressiondsl.ExpressionDSLIndex

@ExtendWith(InjectionExtension)
@InjectWith(ExpressionDSLInjectorProvider)
class ExpressionDSLIndexTest {
	@Inject extension ParseHelper<Model>
	@Inject extension ExpressionDSLIndex 

	@Test
	def void testExportedEObjectDescriptions01() {
		var result = '''
			struct DSName qualified;
				SUBF char DSSubF ;
			ENDstruct;
		'''.parse;

		result.assertExportedEObjectDescriptions("DSName, DSName.DSSubF")

	}

	@Test
	def void testExportedEObjectDescriptions02() {
		var result = '''
			struct DSName00 qualified;
				SUBF char DSSubF00 ;
				struct DSName01 qualified;
					SUBF char DSSubF01 ;
				ENDstruct;
			ENDstruct;
		'''.parse;

		result.assertExportedEObjectDescriptions("DSName00, DSName00.DSSubF00, DSName00.DSName01, DSName00.DSName01.DSSubF01")

	}

	@Test
	def void testExportedEObjectDescriptions03() {
		var result = '''
			struct DSName00 qualified;
				SUBF char DSSubF01 ;
				struct DSName01 qualified;
					SUBF char DSSubF01 ;
				ENDstruct;
				SUBF char DSSubF02 ;
			ENDstruct;
		'''.parse;

		result.assertExportedEObjectDescriptions("DSName00, DSName00.DSSubF01, DSName00.DSName01, DSName00.DSName01.DSSubF01, DSName00.DSSubF02")

	}

	def private assertExportedEObjectDescriptions(EObject o, CharSequence expected) {

//		val a = o.getExportedEObjectDescriptions
//		val b = a.map[qualifiedName]
//		val c = b.join(", ")
//		
//		val result = o.getExportedEObjectDescriptions.map[qualifiedName].join(", ")
//		expected.toString.assertEquals(result)

		expected.toString.assertEquals(
			o.getExportedEObjectDescriptions.map[qualifiedName].join(", ")
		)
	}
}

