package com.cfwx.rox.businesssync.market.wsclient;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.logging.Logger;
import javax.xml.namespace.QName;
import javax.xml.ws.Service;
import javax.xml.ws.WebEndpoint;
import javax.xml.ws.WebServiceClient;

/**
 * This class was generated by the JAX-WS RI. JAX-WS RI 2.1.3-hudson-390-
 * Generated source version: 2.0
 * <p>
 * An example of how this class may be used:
 * 
 * <pre>
 * EjdbWebService service = new EjdbWebService();
 * EjdbWebServiceSoap portType = service.getEjdbWebServiceSoap();
 * portType.getData(...);
 * </pre>
 * 
 * </p>
 * 
 */
@WebServiceClient(name = "EjdbWebService", targetNamespace = "http://www.icfwx.com.cn/", wsdlLocation = "http://59.50.95.63:9999/EjdbWebService.asmx?wsdl")
public class EjdbWebService extends Service {

	private final static URL EJDBWEBSERVICE_WSDL_LOCATION;
	private final static Logger logger = Logger
			.getLogger(EjdbWebService.class.getName());

	static {
		URL url = null;
		try {
			URL baseUrl;
			baseUrl = EjdbWebService.class.getResource(".");
			url = new URL(baseUrl,
					"http://59.50.95.63:9999/EjdbWebService.asmx?wsdl");
		} catch (MalformedURLException e) {
			logger.warning("Failed to create URL for the wsdl Location: 'http://59.50.95.63:9999/EjdbWebService.asmx?wsdl', retrying as a local file");
			logger.warning(e.getMessage());
		}
		EJDBWEBSERVICE_WSDL_LOCATION = url;
	}

	public EjdbWebService(URL wsdlLocation, QName serviceName) {
		super(wsdlLocation, serviceName);
	}

	public EjdbWebService() {
		super(EJDBWEBSERVICE_WSDL_LOCATION, new QName("http://www.icfwx.com.cn/",
				"EjdbWebService"));
	}

	/**
	 * 
	 * @return returns EjdbWebServiceSoap
	 */
	@WebEndpoint(name = "EjdbWebServiceSoap")
	public EjdbWebServiceSoap getEjdbWebServiceSoap() {
		return super.getPort(new QName("http://www.icfwx.com.cn/",
				"EjdbWebServiceSoap"), EjdbWebServiceSoap.class);
	}

	/**
	 * 
	 * @return returns EjdbWebServiceSoap
	 */
	@WebEndpoint(name = "EjdbWebServiceSoap12")
	public EjdbWebServiceSoap getEjdbWebServiceSoap12() {
		return super.getPort(new QName("http://www.icfwx.com.cn/",
				"EjdbWebServiceSoap12"), EjdbWebServiceSoap.class);
	}

}
