/*
 * Copyright (C) 2020 Bonitasoft S.A.
 * Bonitasoft is a trademark of Bonitasoft SA.
 * This software file is BONITASOFT CONFIDENTIAL. Not For Distribution.
 * For commercial licensing information, contact:
 * Bonitasoft, 32 rue Gustave Eiffel – 38000 Grenoble
 * or Bonitasoft US, 51 Federal Street, Suite 305, San Francisco, CA 94107
 */
package org.bonitasoft.tooling.rest.api.logger

import groovy.json.JsonBuilder
import org.bonitasoft.web.extension.rest.RestAPIContext
import org.bonitasoft.web.extension.rest.RestApiController
import org.bonitasoft.web.extension.rest.RestApiResponse
import org.bonitasoft.web.extension.rest.RestApiResponseBuilder

import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import java.util.logging.Level
import java.util.logging.Logger

class Index implements RestApiController {

    @Override
    RestApiResponse doHandle(HttpServletRequest request, RestApiResponseBuilder responseBuilder, RestAPIContext context) {
        // To retrieve query parameters use the request.getParameter(..) method.
        // Be careful, parameter values are always returned as String values

        // parameters retrieval
		def loggerName = request.getParameter 'loggerName'
        if (loggerName == null) {
            return buildResponse(responseBuilder, HttpServletResponse.SC_BAD_REQUEST,"""{"error" : "the 'loggerName' parameter is missing"}""")
        }
		def loggerLevel = request.getParameter 'loggerLevel'
        if (loggerLevel == null) {
            return buildResponse(responseBuilder, HttpServletResponse.SC_BAD_REQUEST,"""{"error" : "the 'loggerLevel' parameter is missing"}""")
        }


        Logger logger = Logger.getLogger(loggerName);
        Level originalLogLevel = logger.getLevel();
        logger.log(originalLogLevel, "{BONITA TOOLING LOGGER REST API} prepare new log level setting");
        logger.setLevel(Level.parse(loggerLevel));
        Level newLogLevel = logger.getLevel();

        logger.log(newLogLevel, "{BONITA TOOLING LOGGER REST API} new log level set. Original: ${originalLogLevel} / New: ${newLogLevel}");

		def result = [:]
        result['requestedLoggerName'] = loggerName
        result['requestedLoggerLevel'] = loggerLevel
        result['actualLoggerName'] = logger.name
        result['originalLogLevel'] = originalLogLevel?.name
        result['newLogLevel'] = newLogLevel?.name

		
        // Send the result as a JSON representation
        // You may use buildPagedResponse if your result is multiple
        return buildResponse(responseBuilder, HttpServletResponse.SC_OK, new JsonBuilder(result).toString())
    }

    /**
     * Build an HTTP response.
     *
     * @param  responseBuilder the Rest API response builder
     * @param  httpStatus the status of the response
     * @param  body the response body
     * @return a RestAPIResponse
     */
    RestApiResponse buildResponse(RestApiResponseBuilder responseBuilder, int httpStatus, Serializable body) {
        return responseBuilder.with {
            withResponseStatus(httpStatus)
            withResponse(body)
            build()
        }
    }

    /**
     * Returns a paged result like Bonita BPM REST APIs.
     * Build a response with a content-range.
     *
     * @param  responseBuilder the Rest API response builder
     * @param  body the response body
     * @param  p the page index
     * @param  c the number of result per page
     * @param  total the total number of results
     * @return a RestAPIResponse
     */
    RestApiResponse buildPagedResponse(RestApiResponseBuilder responseBuilder, Serializable body, int p, int c, long total) {
        return responseBuilder.with {
            withContentRange(p,c,total)
            withResponse(body)
            build()
        }
    }

}
