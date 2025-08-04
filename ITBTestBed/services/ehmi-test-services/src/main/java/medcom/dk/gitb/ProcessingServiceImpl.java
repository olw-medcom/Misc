package medcom.dk.gitb;

import com.gitb.core.ValueEmbeddingEnumeration;
import com.gitb.ps.Void;
import com.gitb.ps.*;
import com.gitb.tr.TestResultType;

import ca.uhn.fhir.context.FhirContext;
import ca.uhn.fhir.context.support.DefaultProfileValidationSupport;
import ca.uhn.fhir.parser.IParser;

import org.hl7.fhir.instance.model.api.IBase;
import org.hl7.fhir.instance.model.api.IPrimitiveType;
import org.hl7.fhir.r4.model.Bundle;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * Spring component that realises the processing service.
 */
@Component
public class ProcessingServiceImpl implements ProcessingService {

    /** Logger. */
    private static final Logger LOG = LoggerFactory.getLogger(ProcessingServiceImpl.class);

    private static final FhirContext FHIR_CONTEXT = initCtx(FhirContext.forR4());

    private static FhirContext initCtx(FhirContext c) {
        c.setValidationSupport(new DefaultProfileValidationSupport(c));
        return c;
    }

    @Autowired
    private Utils utils = null;

    /**
     * The purpose of the getModuleDefinition call is to inform its caller on how
     * the service is supposed to be called.
     * <p/>
     * Note that defining the implementation of this service is optional, and can be
     * empty unless you plan to publish
     * the service for use by third parties (in which case it serves as
     * documentation on its expected inputs and outputs).
     *
     * @param parameters No parameters are expected.
     * @return The response.
     */
    @Override
    public GetModuleDefinitionResponse getModuleDefinition(Void parameters) {
        return new GetModuleDefinitionResponse();
    }

    /**
     * The purpose of the process operation is to execute one of the service's
     * supported operations.
     * <p/>
     * What would typically take place here is as follows:
     * <ol>
     * <li>Check that the requested operation is indeed supported by the
     * service.</li>
     * <li>For the requested operation collect and check the provided input
     * parameters.</li>
     * <li>Perform the requested operation and return the result to the test
     * bed.</li>
     * </ol>
     *
     * @param processRequest The requested operation and input parameters.
     * @return The result.
     */
    @Override
    public ProcessResponse process(ProcessRequest processRequest) {
        var operation = processRequest.getOperation();
        if (operation == null) {
            throw new IllegalArgumentException("No processing operation provided");
        }

        return switch (operation) {
            case "FHIRPath" -> {
                yield processFhirPath(processRequest);
            }
            default -> throw new IllegalArgumentException(String.format("Operation not supported [%s].", operation));
        };
    }

    private ProcessResponse processFhirPath(ProcessRequest processRequest) {
        var fhirResource = utils.getRequiredString(processRequest.getInput(), "fhirResource");
        var fhirResourceType = utils.getRequiredString(processRequest.getInput(), "fhirResourceType");
        var fhirPathExpression = utils.getRequiredString(processRequest.getInput(), "fhirPathExpression");

        IParser parser = switch (fhirResourceType) {
            case "application/fhir+json" -> FHIR_CONTEXT.newJsonParser();
            case "application/fhir+xml" -> FHIR_CONTEXT.newXmlParser();
            default -> throw new IllegalArgumentException(String.format(
                    "Unsupported FHIR resource type [%s]. Should either be 'application/fhir+json' or 'application/fhir+xml'",
                    fhirResourceType));
        };

        var fhirPath = FHIR_CONTEXT.newFhirPath();
        var bundle = (Bundle) parser.parseResource(fhirResource);
        fhirPath.setEvaluationContext(new R4ResolveEvaluationContext(bundle));
        var matches = fhirPath.evaluate(bundle, fhirPathExpression, IBase.class);

        if (matches.isEmpty()) {
            ProcessResponse response = new ProcessResponse();
            response.setReport(utils.createReport(TestResultType.FAILURE));
            response.getOutput().add(utils.createAnyContentSimple("output",
                    "No matches found for the FHIRPath expression.", ValueEmbeddingEnumeration.STRING));
            return response;
        }

        if (matches.size() > 1) {
            ProcessResponse response = new ProcessResponse();
            response.setReport(utils.createReport(TestResultType.FAILURE));
            response.getOutput().add(utils.createAnyContentSimple("output",
                    "Multiple matches found for the FHIRPath expression.", ValueEmbeddingEnumeration.STRING));
            return response;
        }
        var m = matches.get(0);
        String result = "";
        if (m instanceof IPrimitiveType<?> p) {
            result = p.getValueAsString();
        } else {
            result = parser.encodeToString(m);
        }

        var response = new ProcessResponse();
        response.setReport(utils.createReport(TestResultType.SUCCESS));
        response.getOutput().add(utils.createAnyContentSimple("output", result, ValueEmbeddingEnumeration.STRING));
        return response;
    }

    /**
     * The purpose of the beginTransaction operation is to begin a unique processing
     * session.
     * <p/>
     * Transactions are used when processing services need to maintain state across
     * several calls. If this is needed
     * then this implementation would generate a session identifier and record the
     * session for subsequent 'process' calls.
     * <p/>
     * In the typical case where no state needs to be maintained, you can provide an
     * empty implementation for this method.
     *
     * @param beginTransactionRequest Optional configuration parameters to consider
     *                                when starting a processing transaction.
     * @return The response with the generated session ID for the processing
     *         transaction.
     */
    @Override
    public BeginTransactionResponse beginTransaction(BeginTransactionRequest beginTransactionRequest) {
        return new BeginTransactionResponse();
    }

    /**
     * The purpose of the endTransaction operation is to complete an ongoing
     * processing session.
     * <p/>
     * The main actions to be taken as part of this operation are to remove the
     * provided session identifier (if this
     * was being recorded to begin with), and to perform any custom cleanup tasks.
     *
     * @param parameters The identifier of the session to terminate.
     * @return A void response.
     */
    @Override
    public Void endTransaction(BasicRequest parameters) {
        return new Void();
    }

}
