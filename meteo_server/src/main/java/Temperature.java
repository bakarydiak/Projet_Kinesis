import com.google.gson.annotations.SerializedName;


public class Temperature {
    public float getCurrentTemperature() {
        return currentTemperature;
    }

    public void setCurrentTemperature(float currentTemperature) {
        this.currentTemperature = currentTemperature;
    }

    @SerializedName("temp")
    private float currentTemperature;

    @SerializedName("feels_like")
    private float feeling;

    @SerializedName("temp_min")
    private float minimumTemperature;

    @SerializedName("temp_max")
    private float maximumTemperature;

    public float getMinimumTemperature() {
        return minimumTemperature;
    }

    public void setMinimumTemperature(float minimumTemperature) {
        this.minimumTemperature = minimumTemperature;
    }

    public float getMaximumTemperature() {
        return maximumTemperature;
    }

    public void setMaximumTemperature(float maximumTemperature) {
        this.maximumTemperature = maximumTemperature;
    }

    public float getFeeling() {
        return feeling;
    }

    public void setFeeling(float feeling) {
        this.feeling = feeling;
    }
}
