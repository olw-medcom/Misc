package medcom.dk.gitb;

import ca.uhn.fhir.fhirpath.IFhirPathEvaluationContext;
import jakarta.annotation.Nonnull;
import jakarta.annotation.Nullable;
import org.hl7.fhir.instance.model.api.IBase;
import org.hl7.fhir.instance.model.api.IIdType;
import org.hl7.fhir.r4.model.Bundle;

public class R4ResolveEvaluationContext implements IFhirPathEvaluationContext {

  private final Bundle bundle;

  public R4ResolveEvaluationContext(Bundle bundle) {
    this.bundle = bundle;
  }

  @Override
  public IBase resolveReference(@Nonnull IIdType theReference, @Nullable IBase theContext) {
    String referenceValue = theReference.getValue();
    String referenceIdPart = theReference.getIdPart();

    for (Bundle.BundleEntryComponent entry : bundle.getEntry()) {
      if (referenceValue.equals(entry.getFullUrl())) {
        return entry.getResource();
      }

      if (entry.getResource().getIdElement().getIdPart().equals(referenceIdPart)
          && entry
              .getResource()
              .getResourceType()
              .toString()
              .equals(theReference.getResourceType())) {
        return entry.getResource();
      }
    }

    throw new UnsupportedOperationException(
        "Reference resolution not supported for: " + referenceValue);
  }
}
