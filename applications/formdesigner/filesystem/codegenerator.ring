/*
**	Project : Form Designer 
**	File Purpose :  Code Generator
**	Date : 2017.04.29
**	Author :  Mahmoud Fayed <msfclipper@yahoo.com>
*/

package formdesigner

class FormDesignerCodeGenerator

	cSourceFileName

	func Generate oDesigner,cFormFileName
		cSourceFileName = substr(cFormFileName,".rform","View.ring")
		cFormName = GetFileNameOnlyWithoutPath(substr(cFormFileName,".rform",""))
		cClassName = cFormName + "View"
		cClassName = PrepareClassName(cClassName)
		cClassName2 = cFormName + "Controller"
		cClassName2 = PrepareClassName(cClassName2)
		# Add the File Header
			cOutput = "# Form/Window View - Generated Source Code File " + nl +
					"# Generated by the Ring "+version()+" Form Designer" + nl +
					"# Date : " + date() + nl +
					"# Time : " + time() + nl + nl
		# Write general code to show the window
			cOutput += 'Load "stdlib.ring"' + nl +
					'Load "guilib.ring"' + nl + nl +
					'import System.GUI' + nl + nl + 
					"if IsMainSourceFile() { " + nl +
					char(9) + "new App {" + nl +
					char(9) + char(9) + "StyleFusion()" + nl +
					char(9) + char(9) + "new " + cClassName + " { win.show() } " + nl +
					char(9) + char(9) + "exec()" + nl +
					char(9) + "}" + nl +
					 "}" + nl + nl
		# Write the Class
			cOutput += "class " + cClassName + " from WindowsViewParent" + nl +
					char(9) + "win = new MainWindow() { " + nl +
					GenerateWindowCode(oDesigner) +
					GenerateObjectsCode(oDesigner) +
					GenerateWindowCodeAfterObjects(oDesigner) +
					char(9) + "}" + nl + nl
		# Add the End of file
			cOutput += "# End of the Generated Source Code File..."
			cOutput = substr(cOutput,nl,WindowsNL())
			write(cSourceFileName,cOutput)
		# Write the Controller Source File
			cSourceFileName = substr(cFormFileName,".rform","Controller.ring")
			if fexists(cSourceFileName) { return }
			cOutput = `# Form/Window Controller - Source Code File

load "#{f1}View.ring"

import System.GUI

if IsMainSourceFile() {
	new App {
		StyleFusion()
		open_window(:#{f2})
		exec()
	}
}

class #{f2} from windowsControllerParent

	oView = new #{f3}
`
			cOutput = substr(cOutput,"#{f1}",cFormName)
			cOutput = substr(cOutput,"#{f2}",cClassName2)
			cOutput = substr(cOutput,"#{f3}",cClassName)
			write(cSourceFileName,cOutput)

	func PrepareClassName cClassName
		cClassName = substr(cClassName," ","_")
		cClassName = substr(cClassName,"-","_")
		cClassName = substr(cClassName,".","_")
		return cClassName

	func GetFileNameOnlyWithoutPath cFileName
		cFN = cFileName
		nCount = 0
		for x = len(cFileName) to 1 step -1 {
			if cFileName[x] = "/" or cFileName[x] = "\" {
				cFN = right(cFileName,nCount)
				exit
			}
			nCount++
		}
		return cFN

	func GenerateWindowCode oDesigner
		return oDesigner.oModel.FormObject().GenerateCode(oDesigner)

	func GenerateWindowCodeAfterObjects oDesigner
		return oDesigner.oModel.FormObject().GenerateCodeAfterObjects(oDesigner)

	func GenerateObjectsCode oDesigner
		cCode = ""
		for x = 2 to len( oDesigner.oModel.GetObjects() ) {
			oObject = oDesigner.oModel.GetObjects()[x][2]
			cCode += oObject.GenerateCode(oDesigner)
		}
		return cCode
