package org.xtext.example.expressiondsl

import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.resource.impl.ResourceDescriptionsProvider
import com.google.inject.Inject
import org.xtext.example.expressiondsl.expressionDSL.ExpressionDSLPackage

class ExpressionDSLIndex {

	@Inject ResourceDescriptionsProvider rdp

	def getResourceDescription(EObject o) {
		val index = rdp.getResourceDescriptions(o.eResource)
		index.getResourceDescription(o.eResource.URI)
	}

	def getExportedEObjectDescriptions(EObject o) {
		o.getResourceDescription.getExportedObjects
	}

	def getExportedClassesEObjectDescriptions(EObject o) {
		var a = o.getResourceDescription
		var b = a.getExportedObjectsByType(ExpressionDSLPackage.eINSTANCE.structDef)
		var c = a.getExportedObjectsByObject(ExpressionDSLPackage.eINSTANCE.subField)
		
//		o.getResourceDescription.getExportedObjectsByType(ExpressionDSLPackage.eINSTANCE.st)
	}
}
