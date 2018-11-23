package pe.com.gesateped.carga.xlsx.service;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.util.IOUtils;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFClientAnchor;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFDrawing;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFPicture;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFShape;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;

import pe.com.gesateped.carga.model.ErrorCarga;
import pe.com.gesateped.carga.model.ResumenCarga;

@Service
public class XlsxServiceImple implements XlsxService {

	@Override
	public void imprimirErroresDeCarga(OutputStream output,InputStream logo,ResumenCarga resumen) throws IOException {
		XSSFWorkbook workbook = new XSSFWorkbook();
		XSSFSheet xssfSheet = workbook.createSheet("Errores de Carga");
		
		
		//Logo
		byte[] logoBytes = IOUtils.toByteArray(logo);
		int pictureIndex = workbook.addPicture(logoBytes, Workbook.PICTURE_TYPE_PNG);
		logo.close();
		
		XSSFDrawing patriarch = xssfSheet.createDrawingPatriarch();
		XSSFClientAnchor anchor = workbook.getCreationHelper().createClientAnchor();
		anchor.setRow1(0);
		anchor.setCol1(0);
		anchor.setCol2(1);
		
		int LOGO_MARGIN = 2;
		anchor.setDx1(LOGO_MARGIN * XSSFShape.EMU_PER_PIXEL);
		anchor.setDy1(LOGO_MARGIN * XSSFShape.EMU_PER_PIXEL);
		XSSFPicture picture = patriarch.createPicture(anchor, pictureIndex);
		picture.resize(0.6);
		
		//Titulo
		XSSFCellStyle titleStyle = workbook.createCellStyle();
		XSSFFont titleFont = workbook.createFont();
		titleFont.setFontHeightInPoints((short)13);
		titleFont.setBoldweight((short)25);
		titleFont.setBold(true);
		titleFont.setUnderline(HSSFFont.U_SINGLE);
		titleStyle.setFont(titleFont);
		
		XSSFRow lineaTitulo = xssfSheet.createRow(1);
		XSSFCell celdaTitulo = lineaTitulo.createCell(2);
		celdaTitulo.setCellStyle(titleStyle);
		celdaTitulo.setCellValue("LISTA DE ERRORES EN LA CARGA DE DATOS");
		
		//Contenido
		XSSFCellStyle centerStyle = workbook.createCellStyle();
		centerStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		centerStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
		centerStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		centerStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		centerStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		
		XSSFCellStyle leftStyle = workbook.createCellStyle();
		leftStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		leftStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
		leftStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		leftStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		
		XSSFCellStyle colorAndCenterStyle = workbook.createCellStyle();
		colorAndCenterStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		colorAndCenterStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
		colorAndCenterStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		colorAndCenterStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		colorAndCenterStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		//8ea9db
		XSSFColor myColor = new XSSFColor(new java.awt.Color(142,169,219));
		
		colorAndCenterStyle.setFillForegroundColor(myColor);
		colorAndCenterStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
		
		
		int linea = 4;
		
		//Cabecera de tabla
		XSSFRow cabecera = xssfSheet.createRow(linea++);
		XSSFCell cabecera1 = cabecera.createCell(1);
		cabecera1.setCellValue("Registro");
		cabecera1.setCellStyle(colorAndCenterStyle);
		XSSFCell cabecera2 = cabecera.createCell(2);
		cabecera2.setCellValue("Mensaje");
		cabecera2.setCellStyle(colorAndCenterStyle);
		for(ErrorCarga error : resumen.getErrores()) {
			XSSFRow row = xssfSheet.createRow(linea++);
			XSSFCell cell1 = row.createCell(1);
			cell1.setCellValue(error.getRegistro().toString());
			cell1.setCellStyle(centerStyle);
			
			XSSFCell cell2 = row.createCell(2);
			cell2.setCellValue(error.getMensaje());
			cell2.setCellStyle(leftStyle);
		}
		xssfSheet.autoSizeColumn(2);
		workbook.write(output);
	}

}
