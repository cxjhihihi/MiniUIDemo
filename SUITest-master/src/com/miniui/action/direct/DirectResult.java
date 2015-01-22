/*
 * $Id: PlainTextResult.java 471756 2006-11-06 15:01:43Z husted $
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */




package com.miniui.action.direct;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.PageContext;

import org.apache.struts2.ServletActionContext;
import org.apache.struts2.dispatcher.StrutsResultSupport;

import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.util.TextParseUtil;
import com.opensymphony.xwork2.util.logging.Logger;
import com.opensymphony.xwork2.util.logging.LoggerFactory;

public class DirectResult extends StrutsResultSupport {

	private static final Logger LOG = LoggerFactory.getLogger(StrutsResultSupport.class);

    private static final long serialVersionUID = 3633371605905583950L;

	private boolean prependServletContext = true;

    public DirectResult() {
        super();
    }

    public DirectResult(String location) {
        super(location);
    }

    /**
     * Sets whether or not to prepend the servlet context path to the redirected URL.
     *
     * @param prependServletContext <tt>true</tt> to prepend the location with the servlet context path,
     *                              <tt>false</tt> otherwise.
     */
    public void setPrependServletContext(boolean prependServletContext) {
        this.prependServletContext = prependServletContext;
    }
    
    /* (non-Javadoc)
     * @see org.apache.struts2.dispatcher.StrutsResultSupport#doExecute(java.lang.String, com.opensymphony.xwork2.ActionInvocation)
     */
    protected void doExecute(String finalLocation,ActionInvocation invocation) throws Exception {
        HttpServletResponse response = (HttpServletResponse) invocation.getInvocationContext().get(HTTP_RESPONSE);
        HttpServletRequest request = (HttpServletRequest) invocation.getInvocationContext().get(HTTP_REQUEST);
       
        String resultCodeAsLocation = invocation.getResultCode();
        if(resultCodeAsLocation == null) {
        	response.sendError(404, "result '" + resultCodeAsLocation + "' not found");
 		    return;
        }
        
        //proecss with ONGL expression
		resultCodeAsLocation = TextParseUtil.translateVariables(resultCodeAsLocation,invocation.getStack());
        
        if(resultCodeAsLocation.startsWith("!")) {
        	doRedirect(invocation,request, response, resultCodeAsLocation.substring(1));
        }else {
        	doDispatcher(response, request, resultCodeAsLocation);
        }
    }

	private void doDispatcher(HttpServletResponse response, HttpServletRequest request, String resultCodeAsLocation) throws IOException, ServletException {
		if (LOG.isInfoEnabled()) {
		    LOG.info("Forwarding to location:" + resultCodeAsLocation);
		}
		
		PageContext pageContext = ServletActionContext.getPageContext();
		if (pageContext != null) {
            pageContext.include(resultCodeAsLocation);
            return;
		}
		
		RequestDispatcher dispatcher = request.getRequestDispatcher(resultCodeAsLocation);
		if (dispatcher == null) {
		    response.sendError(404, "result '" + resultCodeAsLocation + "' not found");
		    return;
		}
		
		if (!response.isCommitted() && (request.getAttribute("javax.servlet.include.servlet_path") == null)) {
		    request.setAttribute("struts.view_uri", resultCodeAsLocation);
		    request.setAttribute("struts.request_uri", request.getRequestURI());

		    dispatcher.forward(request, response);
		} else {
		    dispatcher.include(request, response);
		}
	}

	private void doRedirect(ActionInvocation invocation,HttpServletRequest request, HttpServletResponse response, String redirectLocation) throws IOException {
		if(isPathUrl(redirectLocation)) {
			if(!redirectLocation.startsWith("/")) {
				String namespace = invocation.getProxy().getNamespace();
                if ((namespace != null) && (namespace.length() > 0) && (!"/".equals(namespace))) {
                	redirectLocation = namespace + "/" + redirectLocation;
                } else {
                	redirectLocation = "/" + redirectLocation;
                }
			}
			if (prependServletContext  && (request.getContextPath() != null) && (request.getContextPath().length() > 0)) {
				redirectLocation = request.getContextPath() + redirectLocation;
            }
		}
		
		if(LOG.isInfoEnabled())
			LOG.info("Redirect to location:"+redirectLocation);
		response.sendRedirect(response.encodeRedirectURL(redirectLocation));
	}
    
    private static boolean isPathUrl(String url) {
        // filter out "http:", "https:", "mailto:", "file:", "ftp:"
        // since the only valid places for : in URL's is before the path specification
        // either before the port, or after the protocol
        return (url.indexOf(':') == -1);
    }
}
